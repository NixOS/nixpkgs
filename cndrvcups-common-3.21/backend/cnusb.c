/*
 *  CUPS backend for a USB Delay Open.
 *  Copyright CANON INC. 2009
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

//
//  '2009.09.02
//  Using the original "usb.c" code of the CUPS 1.2.12 to create a new backend for a USB Delay Open.
//

/*
 * "$Id: cnusb.c,v 1.1.1.1 2010/07/08 09:30:54 207046 Exp $"
 *
 *   USB port backend for the Common UNIX Printing System (CUPS).
 *
 *   Copyright 1997-2007 by Easy Software Products, all rights reserved.
 *
 *   These coded instructions, statements, and computer programs are the
 *   property of Easy Software Products and are protected by Federal
 *   copyright law.  Distribution and use rights are outlined in the file
 *   "LICENSE" which should have been included with this file.  If this
 *   file is missing or damaged please contact Easy Software Products
 *   at:
 *
 *       Attn: CUPS Licensing Information
 *       Easy Software Products
 *       44141 Airport View Drive, Suite 204
 *       Hollywood, Maryland 20636 USA
 *
 *       Voice: (301) 373-9600
 *       EMail: cups-info@cups.org
 *         WWW: http://www.cups.org
 *
 *   This file is subject to the Apple OS-Developed Software exception.
 *
 * Contents:
 *
 *   list_devices() - List all available USB devices to stdout.
 *   print_device() - Print a file to a USB device.
 *   main()         - Send a file to the specified USB port.
 */

/*
 * Include necessary headers.
 */




#include <cups/cups.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <errno.h>
#include <signal.h>
#include <stdarg.h>
#include <fcntl.h>
#include <termios.h>
#include <sys/select.h>
#include <sys/ioctl.h>

#define IOCNR_GET_DEVICE_ID             1
#define LPIOC_GET_DEVICE_ID(len)        _IOC(_IOC_READ, 'P', IOCNR_GET_DEVICE_ID, len)

#define DEVICE_URI_PREFIX               "cnusb:"



void    DBGMSG(int feed, const char *fmt, ...);
ssize_t backendRunLoop(int print_fd, int device_fd);
int     backendGetDeviceID(int fd, char *device_id, int device_id_size,
                           char *make_model, int make_model_size, const char *schema,
                           char *uri, int uri_size);
int     backendGetMakeModel(const char *device_id, char *make_model, int make_model_size);
int     print_device(const char *uri, const char *hostname,
                     const char *resource, const char *options,
                     int print_fd, int copies, int argc, char *argv[]);
void    list_devices(void);
int     open_device(const char *uri);


void DBGMSG(
        int bFeed,
        const char *fmt, ...
)
{
#ifdef _CNUSB_DEBUG_
  FILE    *ifd = NULL;
  va_list vap;
  char    szText[2048];
  char    cFile[255];

  sprintf(cFile, "/tmp/cnusb.txt");
  memset(szText, 0, sizeof(szText));
  va_start(vap, fmt);
  ifd = fopen(cFile,"a+");
  if (ifd != NULL)
  {
    vsprintf(szText, fmt, vap);

    if (bFeed)
    {
      szText[strlen(szText)] = '\n';
    }
    fwrite(szText, 1, strlen(szText), ifd);
    fclose(ifd);
  }
#endif
}



size_t
mystrlcpy(char     *dst,
        const char *src,
        size_t      size)
{
  size_t        srclen;


  size --;
  srclen = strlen(src);


  if (srclen > size)
    srclen = size;

  memcpy(dst, src, srclen);
  dst[srclen] = '\0';

  return (srclen);
}


size_t
mystrlcat(char     *dst,
        const char *src,
        size_t     size)
{
  size_t        srclen;
  size_t        dstlen;


  dstlen = strlen(dst);
  size   -= dstlen + 1;

  if (!size)
    return (dstlen);


  srclen = strlen(src);


  if (srclen > size)
    srclen = size;

  memcpy(dst + dstlen, src, srclen);
  dst[dstlen + srclen] = '\0';

  return (dstlen + srclen);
}


ssize_t
backendRunLoop(int print_fd,
               int device_fd)
{
  int           nfds;
  fd_set        input,
                output;
  ssize_t       print_bytes,
                total_bytes,
                bytes;
  int           paperout;
  int           offline;
  char          print_buffer[8192],
                *print_ptr;
  struct timeval timeout;
#if defined(HAVE_SIGACTION) && !defined(HAVE_SIGSET)
  struct sigaction action;
#endif


  DBGMSG( 1, "backendRunLoop() " );

  fprintf(stderr, "DEBUG: backendRunLoop(print_fd=%d, device_fd=%d)\n",
          print_fd, device_fd);


  if (!print_fd)
  {
#ifdef HAVE_SIGSET
    sigset(SIGTERM, SIG_IGN);
#elif defined(HAVE_SIGACTION)
    memset(&action, 0, sizeof(action));

    sigemptyset(&action.sa_mask);
    action.sa_handler = SIG_IGN;
    sigaction(SIGTERM, &action, NULL);
#else
    signal(SIGTERM, SIG_IGN);
#endif
  }


  nfds = (print_fd > device_fd ? print_fd : device_fd) + 1;


  for (print_bytes = 0, print_ptr = print_buffer, offline = 0,
           paperout = -1, total_bytes = 0;;)
  {

    FD_ZERO(&input);
    if (!print_bytes)
      FD_SET(print_fd, &input);

    FD_ZERO(&output);
    if (print_bytes)
      FD_SET(device_fd, &output);

    timeout.tv_sec = 5;
    timeout.tv_usec = 0;

    if (select(nfds, &input, &output, NULL, &timeout) < 0)
    {

      if (errno == ENXIO && offline != 1)
      {
        fputs("STATE: +offline-error\n", stderr);
        fputs("INFO: Printer is currently off-line.\n", stderr);
        offline = 1;
      }
      else if (errno == EINTR && total_bytes == 0)
      {
        fputs("DEBUG: Received an interrupt before any bytes were "
              "written, aborting!\n", stderr);
        return (0);
      }

      sleep(1);
      continue;
    }


    if (FD_ISSET(print_fd, &input))
    {
      if ((print_bytes = read(print_fd, print_buffer,
                              sizeof(print_buffer))) < 0)
      {

        if (errno != EAGAIN || errno != EINTR)
        {
          perror("ERROR: Unable to read print data");
          return (-1);
        }

        print_bytes = 0;
      }
      else if (print_bytes == 0)
      {

        break;
      }

      print_ptr = print_buffer;

      fprintf(stderr, "DEBUG: Read %d bytes of print data...\n",
              (int)print_bytes);
    }


    if (print_bytes && FD_ISSET(device_fd, &output))
    {
      if ((bytes = write(device_fd, print_ptr, print_bytes)) < 0)
      {

        if (errno == ENOSPC)
        {
          if (paperout != 1)
          {
            fputs("ERROR: Out of paper!\n", stderr);
            fputs("STATE: +media-empty-error\n", stderr);
            paperout = 1;
          }
        }
        else if (errno == ENXIO)
        {
          if (offline != 1)
          {
            fputs("STATE: +offline-error\n", stderr);
            fputs("INFO: Printer is currently off-line.\n", stderr);
            offline = 1;
          }
        }
        else if (errno != EAGAIN && errno != EINTR && errno != ENOTTY)
        {
          perror("ERROR: Unable to write print data");
          return (-1);
        }
      }
      else
      {
        if (paperout)
        {
          fputs("STATE: -media-empty-error\n", stderr);
          paperout = 0;
        }

        if (offline)
        {
          fputs("STATE: -offline-error\n", stderr);
          fputs("INFO: Printer is now on-line.\n", stderr);
          offline = 0;
        }

        fprintf(stderr, "DEBUG: Wrote %d bytes of print data...\n", (int)bytes);

        print_bytes -= bytes;
        print_ptr   += bytes;
        total_bytes += bytes;
      }
    }
  }


  return (total_bytes);
}



int
backendGetDeviceID(
    int        fd,
    char       *device_id,
    int        device_id_size,
    char       *make_model,
    int        make_model_size,
    const char *scheme,
    char       *uri,
    int        uri_size)
{
  char  *attr,
        *delim,
        *uriptr,
        manufacturer[256],
        serial_number[1024];
  int   manulen;
  int   length;


  if (fd < 0 ||
      !device_id || device_id_size < 32 ||
      !make_model || make_model_size < 32)
  {
    return (-1);
  }

  *device_id  = '\0';
  *make_model = '\0';

  if (uri)
    *uri = '\0';


  if (!ioctl(fd, LPIOC_GET_DEVICE_ID(device_id_size), device_id))
  {

    length = (((unsigned)device_id[0] & 255) << 8) +
              ((unsigned)device_id[1] & 255);


    if (length > (device_id_size - 2))
      length = (((unsigned)device_id[1] & 255) << 8) +
                ((unsigned)device_id[0] & 255);

    if (length > (device_id_size - 2))
      length = device_id_size - 2;


    length -= 2;

    memmove(device_id, device_id + 2, length);
    device_id[length] = '\0';

  }
#ifdef DEBUG
  else
    printf("backendGetDeviceID: ioctl failed - %s\n", strerror(errno));
#endif

  if (!*device_id)
    return (-1);


  backendGetMakeModel(device_id, make_model, make_model_size);


  if (scheme && uri && uri_size > 32)
  {

    if ((attr = strstr(device_id, "SERN:")) != NULL)
      attr += 5;
    else if ((attr = strstr(device_id, "SERIALNUMBER:")) != NULL)
      attr += 13;
    else if ((attr = strstr(device_id, ";SN:")) != NULL)
      attr += 4;

    if (attr)
    {
      mystrlcpy(serial_number, attr, sizeof(serial_number));

      if ((delim = strchr(serial_number, ';')) != NULL)
        *delim = '\0';
    }
    else
      serial_number[0] = '\0';


    snprintf(uri, uri_size, "%s://", scheme);

    if ((attr = strstr(device_id, "MANUFACTURER:")) != NULL)
      attr += 13;
    else if ((attr = strstr(device_id, "Manufacturer:")) != NULL)
      attr += 13;
    else if ((attr = strstr(device_id, "MFG:")) != NULL)
      attr += 4;

    if (attr)
    {
      mystrlcpy(manufacturer, attr, sizeof(manufacturer));

      if ((delim = strchr(manufacturer, ';')) != NULL)
        *delim = '\0';
    }
    else
    {
      mystrlcpy(manufacturer, make_model, sizeof(manufacturer));

      if ((delim = strchr(manufacturer, ' ')) != NULL)
        *delim = '\0';
    }

    manulen = strlen(manufacturer);

    for (uriptr = uri + strlen(uri), delim = manufacturer;
         *delim && uriptr < (uri + uri_size - 3);
         delim ++)
      if (*delim == ' ')
      {
        *uriptr++ = '%';
        *uriptr++ = '2';
        *uriptr++ = '0';
      }
      else
        *uriptr++ = *delim;

    *uriptr++ = '/';

    if (!strncasecmp(make_model, manufacturer, manulen))
    {
      delim = make_model + manulen;

      while (isspace(*delim & 255))
        delim ++;
    }
    else
      delim = make_model;

    for (; *delim && uriptr < (uri + uri_size - 3); delim ++)
      if (*delim == ' ')
      {
        *uriptr++ = '%';
        *uriptr++ = '2';
        *uriptr++ = '0';
      }
      else
        *uriptr++ = *delim;

    if (serial_number[0])
    {

      mystrlcpy(uriptr, "?serial=", uri_size - (uriptr - uri));
      mystrlcat(uriptr, serial_number, uri_size - (uriptr - uri));
    }
    else
      *uriptr = '\0';
  }

  return (0);
}



int
backendGetMakeModel(
    const char *device_id,
    char       *make_model,
    int        make_model_size)
{
  char  *attr,
        *delim,
        *mfg,
        *mdl;


  if (!device_id || !*device_id || !make_model || make_model_size < 32)
  {
    return (-1);
  }

  *make_model = '\0';


  if ((attr = strstr(device_id, "DES:")) != NULL)
    attr += 4;
  else if ((attr = strstr(device_id, "DESCRIPTION:")) != NULL)
    attr += 12;

  if (attr)
  {

    if ((delim = strchr(attr, ';')) == NULL)
      delim = attr + strlen(attr);

    if ((delim - attr) < 8)
      attr = NULL;
    else
    {
      char      *ptr;
      int       letters,
                spaces;

      for (ptr = attr, letters = 0, spaces = 0; ptr < delim; ptr ++)
      {
        if (isspace(*ptr & 255))
          spaces ++;
        else if (isalpha(*ptr & 255))
          letters ++;

        if (spaces && letters)
          break;
      }

      if (!spaces || !letters)
        attr = NULL;
    }
  }

  if ((mfg = strstr(device_id, "MANUFACTURER:")) != NULL)
    mfg += 13;
  else if ((mfg = strstr(device_id, "Manufacturer:")) != NULL)
    mfg += 13;
  else if ((mfg = strstr(device_id, "MFG:")) != NULL)
    mfg += 4;

  if ((mdl = strstr(device_id, "MODEL:")) != NULL)
    mdl += 6;
  else if ((mdl = strstr(device_id, "Model:")) != NULL)
    mdl += 6;
  else if ((mdl = strstr(device_id, "MDL:")) != NULL)
    mdl += 4;

  if (mdl)
  {

    if (mfg)
    {
      mystrlcpy(make_model, mfg, make_model_size);

      if ((delim = strchr(make_model, ';')) != NULL)
        *delim = '\0';

      if (!strncasecmp(make_model, mdl, strlen(make_model)))
      {

        mystrlcpy(make_model, mdl, make_model_size);
      }
      else
      {

        mystrlcat(make_model, " ", make_model_size);
        mystrlcat(make_model, mdl, make_model_size);
      }
    }
    else
    {

      mystrlcpy(make_model, mdl, make_model_size);
    }
  }
  else if (attr)
  {

    mystrlcpy(make_model, attr, make_model_size);
  }
  else
  {

    mystrlcpy(make_model, "Unknown", make_model_size);
  }


  if ((delim = strchr(make_model, ';')) != NULL)
    *delim = '\0';


  for (delim = make_model + strlen(make_model) - 1; delim >= make_model; delim --)
    if (isspace(*delim & 255))
      *delim = '\0';
    else
      break;


  if (make_model[0])
    return (0);
  else
    return (-1);
}



int
print_device(const char *uri,
             const char *hostname,
             const char *resource,
             const char *options,
             int        print_fd,
             int        copies,
             int        argc,
             char      *argv[])
{
  int           device_fd;
  size_t        tbytes;
  struct termios opts;
  fd_set        input;
  struct timeval timeout;
  int           nsel;

  (void)argc;
  (void)argv;

  DBGMSG( 1, "print_device() " );



  fputs("STATE: +connecting-to-device\n", stderr);

  device_fd = -1;


  do
  {
    if (print_fd == 0)
    {
      FD_ZERO(&input);
      FD_SET(print_fd, &input);

      timeout.tv_sec = 5;
      timeout.tv_usec = 0;

      DBGMSG( 1, "select call" );


      if ((nsel = select(print_fd+1, &input, NULL, NULL, &timeout)) < 0)
      {

        DBGMSG( 1, "select() = %d", errno );

        if (errno == ENXIO)
        {
          fputs("STATE: +offline-error\n", stderr);
          fputs("INFO: Printer is currently off-line.\n", stderr);
        }
        else if (errno == EINTR)
        {
          fputs("DEBUG: Received an interrupt before any bytes were "
                "written, aborting!\n", stderr);
          return (0);
        }

        sleep(1);
        continue;
      }

      if (nsel == 0)
      {
        DBGMSG( 1, "select() timeout" );
        continue;
      }
    }

    DBGMSG( 1, "open_device() call" );

    if ((device_fd = open_device(uri)) == -1)
    {
      if (getenv("CLASS") != NULL)
      {

        fputs("INFO: Unable to open USB device, queuing on next printer in class...\n",
              stderr);


        sleep(5);

        return (1);
      }

      if (errno == EBUSY)
      {
        fputs("INFO: USB port busy; will retry in 30 seconds...\n", stderr);
        sleep(30);
      }
      else if (errno == ENXIO || errno == EIO || errno == ENOENT ||
               errno == ENODEV)
      {
        fputs("INFO: Printer not connected; will retry in 30 seconds...\n", stderr);
        sleep(30);
      }
      else
      {
        fprintf(stderr, "ERROR: Unable to open USB device \"%s\": %s\n",
                uri, strerror(errno));
        return (1);
      }
    }
  }
  while (device_fd < 0);

  fputs("STATE: -connecting-to-device\n", stderr);



  tcgetattr(device_fd, &opts);

  opts.c_lflag &= ~(ICANON | ECHO | ISIG);


  tcsetattr(device_fd, TCSANOW, &opts);


  tbytes = 0;

  while (copies > 0 && tbytes >= 0)
  {
    copies --;

    if (print_fd != 0)
    {
      fputs("PAGE: 1 1\n", stderr);
      lseek(print_fd, 0, SEEK_SET);
    }

    tbytes = backendRunLoop(print_fd, device_fd);

    if (print_fd != 0 && tbytes >= 0)
      fprintf(stderr, "INFO: Sent print file, %ld bytes...\n", (long)tbytes);
  }


  close(device_fd);

  return ((tbytes < 0) ? 1 : 0);
}


void
list_devices(void)
{
  int   i;
  int   fd;
  char  device[255],
        device_id[1024],
        device_uri[1024],
        make_model[1024];


  for (i = 0; i < 16; i ++)
  {

    sprintf(device, "/dev/usblp%d", i);

    if ((fd = open(device, O_RDWR | O_EXCL)) < 0)
    {
      if (errno != ENOENT)
        continue;

      sprintf(device, "/dev/usb/lp%d", i);

      if ((fd = open(device, O_RDWR | O_EXCL)) < 0)
      {
        if (errno != ENOENT)
          continue;

        sprintf(device, "/dev/usb/usblp%d", i);

        if ((fd = open(device, O_RDWR | O_EXCL)) < 0)
          continue;
      }
    }

    if (!backendGetDeviceID(fd, device_id, sizeof(device_id),
                            make_model, sizeof(make_model),
                            DEVICE_URI_PREFIX, device_uri, sizeof(device_uri)))
    if (strstr(make_model, "Canon") != 0)
      printf("direct %s%s \"%s\" \"%s CNUSB #%d\" \n", DEVICE_URI_PREFIX, device,
             make_model, make_model, i + 1);

    close(fd);
  }
}



int
open_device(const char *uri)
{
  int  fd;

  if (strncmp(uri, DEVICE_URI_PREFIX, strlen(DEVICE_URI_PREFIX)))
  {

    errno = ENODEV;
    return (-1);
  }

  if ((fd = open(uri+strlen(DEVICE_URI_PREFIX), O_RDWR | O_EXCL)) < 0 && errno == ENOENT)
  {
    errno = ENODEV;
    return (-1);
  }
  return (fd);


#if 0
  if (!strncmp(uri, DEVICE_URI_PREFIX, strlen(DEVICE_URI_PREFIX)))
  {

    int         i;
    int         busy;
    char        device[255],
                device_id[1024];
                make_model[1024],
                device_uri[1024];



    do
    {
      for (busy = 0, i = 0; i < 16; i ++)
      {

        sprintf(device, "/dev/usblp%d", i);

        if ((fd = open(device, O_RDWR | O_EXCL)) < 0 && errno == ENOENT)
        {
          sprintf(device, "/dev/usb/lp%d", i);

          if ((fd = open(device, O_RDWR | O_EXCL)) < 0 && errno == ENOENT)
          {
            sprintf(device, "/dev/usb/usblp%d", i);

            if ((fd = open(device, O_RDWR | O_EXCL)) < 0 && errno == ENOENT)
              continue;
          }
        }

        if (fd >= 0)
        {
          backendGetDeviceID(fd, device_id, sizeof(device_id),
                             make_model, sizeof(make_model),
                             DEVICE_URI_PREFIX, device_uri, sizeof(device_uri));
        }
        else
        {

          if (errno == EBUSY)
            busy = 1;

          device_uri[0] = '\0';
        }

        if (!strcmp(uri, device_uri))
        {

          fprintf(stderr, "DEBUG: Printer using device file \"%s\"...\n", device);

          return (fd);
        }


        if (fd >= 0)
          close(fd);
      }


      if (busy)
      {
        fputs("INFO: USB printer is busy; will retry in 5 seconds...\n",
              stderr);
        sleep(5);
      }
    }
    while (busy);


    errno = ENODEV;

    return (-1);
  }
  else
  {
    errno = ENODEV;
    return (-1);
  }
#endif
}



int
main(int  argc,
     char *argv[])
{
  int           print_fd;
  int           copies;
  int           status;
  int           port;
  const char    *uri;
  char          method[255],
                hostname[1024],
                username[255],
                resource[1024],
                *options;
#if defined(HAVE_SIGACTION) && !defined(HAVE_SIGSET)
  struct sigaction action;
#endif



  setbuf(stderr, NULL);


#ifdef HAVE_SIGSET
  sigset(SIGPIPE, SIG_IGN);
#elif defined(HAVE_SIGACTION)
  memset(&action, 0, sizeof(action));
  action.sa_handler = SIG_IGN;
  sigaction(SIGPIPE, &action, NULL);
#else
  signal(SIGPIPE, SIG_IGN);
#endif


  if (argc == 1)
  {
    list_devices();
    return (0);
  }
  else if (argc < 6 || argc > 7)
  {
    fputs("Usage: cnusb job-id user title copies options [file]\n", stderr);
    return (1);
  }


  if (strncmp(argv[0], DEVICE_URI_PREFIX, strlen(DEVICE_URI_PREFIX)))
    uri = getenv("DEVICE_URI");
  else
    uri = argv[0];

  if (!uri)
  {
    fputs("ERROR: No device URI found in argv[0] or in DEVICE_URI environment variable!\n", stderr);
    return (1);
  }

  httpSeparate(argv[0], method, username, hostname, &port, resource);


  if ((options = strchr(resource, '?')) != NULL)
  {

    *options++ = '\0';
  }


  if (argc == 6)
  {
    print_fd = 0;
    copies   = 1;
  }
  else
  {

    if ((print_fd = open(argv[6], O_RDONLY)) < 0)
    {
      fprintf(stderr, "ERROR: unable to open print file %s - %s\n",
              argv[6], strerror(errno));
      return (1);
    }

    copies = atoi(argv[4]);
  }


  status = print_device(uri, hostname, resource, options, print_fd, copies,
                        argc, argv);


  if (print_fd != 0)
    close(print_fd);

  return (status);
}


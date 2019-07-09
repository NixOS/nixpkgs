=================================================================================
Canon CAPT Printer Driver for Linux Version 2.71

PLEASE READ THIS DOCUMENT CAREFULLY
=================================================================================


---------------------------------------------------------------------------------
Trademarks

Adobe, Acrobat, Acrobat Reader, PostScript and PostScript 3 are trademarks of
Adobe Systems Incorporated.
Linux is a trademark of Linus Torvalds.
OpenOffice.org and the seagull logo are registered trademarks of The 
Apache Software Foundation.
HP-GL is a trademark of Hewlett-Packard Company.
UNIX is a trademark of The Open Group in the United States and other countries.
Other product and company names herein may be the trademarks of their respective
owners.
---------------------------------------------------------------------------------


---------------------------------------------------------------------------------
CONTENTS

Before Starting
1. Introduction
2. Distribution File Structure of the Canon CAPT Printer Driver for Linux
3. Hardware Requirements
4. Auto startup setting procedure for ccpd daemon
5. Cautions, Limitations, and Restrictions
6. Appendix
---------------------------------------------------------------------------------


1. Introduction -----------------------------------------------------------------
Thank you for using the Canon CAPT Printer Driver for Linux. This CAPT printer 
driver provides printing functions for Canon LBP printers operating under the 
CUPS (Common Unix Printing System) environment, a printing system that functions 
on Linux operating systems.


2. Distribution File Structure of the Canon CAPT Printer Driver for Linux -------
The Canon CAPT Printer Driver for Linux distribution files are as follows:
Furthermore, the file name for the CUPS driver common module and printer
driver module differs depending on the version.

- README-capt-2.7xUK.txt (This document)
Describes supplementary information on the Canon CAPT Printer Driver for Linux.

- LICENSE-captdrv-2.7xE.txt
Describes User License Agreement on the Canon CAPT Printer Driver for Linux.

- guide-capt-2.7xUK.tar.gz
Online manual that explains how to use the Canon CAPT Printer Driver for Linux.
This includes the system requirements, installation, and usage of the Canon CAPT
Printer Driver for Linux.
Because this file is in a compressed format, you need to extract it to the
appropriate directory before reading.

- cndrvcups-common-3.21-x.i386.rpm (for 32-bit)
- cndrvcups-common-3.21-x.x86_64.rpm (for 64-bit)
- cndrvcups-common_3.21-x_i386.deb (for Debian 32-bit)
- cndrvcups-common_3.21-x_amd64.deb (for Debian 64-bit)
Installation package for the CUPS driver common module used by the Canon CAPT
Printer Driver for Linux.

- cndrvcups-capt-2.71-x.i386.rpm (for 32-bit)
- cndrvcups-capt-2.71-x.x86_64.rpm (for 64-bit)
- cndrvcups-capt_2.71-x_i386.deb (for Debian 32-bit)
- cndrvcups-capt_2.71-x_amd64.deb (for Debian 64-bit)
Installation package for the Canon CAPT Printer Driver for Linux.

- cndrvcups-common-3.21-x.tar.gz
Source file for the CUPS driver common module used by the Canon CAPT Printer
Driver for Linux.

- cndrvcups-capt-2.71-x.tar.gz
Source file for the Canon CAPT Printer Driver for Linux.


3. Hardware Requirements --------------------------------------------------------
This printer driver can be used with the following hardware environment.

Hardware:
    Computer that is enable to operate Linux, with x86 compatible CPU
    (32-bit or 64-bit)

Evaluated OS:
    Fedora 21 32-bit/64-bit
    Ubuntu 14.10 Desktop 32-bit/64-bit

Previously Evaluated OS:
    Turbolinux 10 Desktop 32-bit
    Turbolinux 10 F... 32-bit
    Turbolinux 10 S 32-bit
    Turbolinux Version 11 FUJI 32-bit
    Turbolinux Home 32-bit
    MIRACLE LINUX V3.0(Asianux Inside) 32-bit
    MIRACLE LINUX V4.0(Asianux Inside) 32-bit
    Red Hat 9 32-bit
    Red Hat Professional Workstation 32-bit
    Red Hat Enterprise Linux v.4 32-bit
    Red Hat Enterprise Linux v.5 32-bit
    Mandriva Linux One 2008* 1 32-bit
    Mandriva Linux Powerpack 2008 32-bit
    Mandriva Linux One 2008 Spring 32-bit
    Mandriva Linux One 2009.0 32-bit
    SUSE LINUX PROFESSIONAL 9.3 32-bit
    Novell Linux Desktop 9 32-bit
    SUSE Linux 10.0 (openSUSE) 32-bit
    SUSE Linux 10.1 (openSUSE) 32-bit
    SUSE Linux 10.2 (openSUSE) 32-bit
    SUSE Linux 10.3 (openSUSE) 32-bit
    SUSE Linux 11.0 (openSUSE) 32-bit
    SUSE Linux 11.1 (openSUSE) 32-bit
    Fedora Core 4 32-bit
    Fedora Core 5 32-bit
    Fedora Core 6 32-bit
    Fedora 7 32-bit
    Fedora 8 32-bit
    Fedora 9 32-bit
    Fedora 10 32-bit
    Fedora 11 32-bit
    Fedora 12 32-bit/64-bit
    Fedora 13 32-bit/64-bit
    Fedora 14 32-bit/64-bit
    Fedora 15 32-bit/64-bit
    Fedora 16 32-bit/64-bit
    Fedora 17 32-bit/64-bit
    Fedora 18 32-bit/64-bit
    Fedora 19 32-bit/64-bit
    Fedora 20 32-bit/64-bit
    Ubuntu 7.04 Desktop 32-bit
    Ubuntu 7.10 Desktop 32-bit
    Ubuntu 8.04 Desktop 32-bit
    Ubuntu 8.10 Desktop 32-bit
    Ubuntu 9.04 Desktop 32-bit
    Ubuntu 9.10 Desktop 32-bit
    Ubuntu 10.04 Desktop 32-bit
    Ubuntu 10.10 Desktop 32-bit
    Ubuntu 11.04 Desktop 32-bit
    Ubuntu 11.10 Desktop 32-bit
    Ubuntu 12.04 Desktop 32-bit/64-bit
    Ubuntu 14.04 Desktop 32-bit/64-bit
    Debian GNU/Linux 3.1 rev2 32-bit
    Debian GNU/Linux 4.0 32-bit
    Debian GNU/Linux 4.0 r6 etchnhalf 32-bit
    Debian GNU/Linux 5.02 32-bit
    Vine Linux 3.1/3.1CR 32-bit
    Vine Linux 4.1 32-bit
    Vine Linux 4.2 32-bit
    Cent OS 5.3

Object Printer:
    The Canon CAPT Printer Driver for Linux supports the following Canon 
    products.
    Please refer the following to find the PPD file for your Canon CAPT 
    Printer Driver.

    Canon LBP9100C (CNCUPSLBP9100CCAPTK.ppd)
    LBP9100Cdn

    Canon LBP7210C (CNCUPSLBP7210CCAPTK.ppd)
    LBP7210Cdn 

    Canon LBP7200C (CNCUPSLBP7200CCAPTK.ppd)
    LBP7200C series

    Canon LBP7010C/7018C (CNCUPSLBP7018CCAPTK.ppd)
    LBP7018C/LBP7010C

    Canon LBP6310 (CNCUPSLBP6310CAPTK.ppd)
    LBP6310dn 

    Canon LBP6300 (CNCUPSLBP6300CAPTK.ppd)
    LBP6300dn

    Canon LBP6300n (CNCUPSLBP6300nCAPTK.ppd)
    LBP6300n

    Canon LBP6200 (CNCUPSLBP6200CAPTK.ppd)
    LBP6200

    Canon LBP6020 (CNCUPSLBP6020CAPTK.ppd)
    LBP6020 

    Canon LBP6000/6018 (CNCUPSLBP6018CAPTK.ppd)
    LBP6018/LBP6000

    Canon LBP5300 (CNCUPSLBP5300CAPTK.ppd)
    LBP5300
 
    Canon LBP5100 (CNCUPSLBP5100CAPTK.ppd)
    LBP5100

    Canon LBP5050 (CNCUPSLBP5050CAPTK.ppd)
    LBP5050 series

    Canon LBP5000 (CNCUPSLBP5050CAPTK.ppd)
    LBP5000

    Canon LBP3500 (CNCUPSLBP3500CAPTK.ppd)
    LBP3500

    Canon LBP3310 (CNCUPSLBP3310CAPTK.ppd)
    LBP3310

    Canon LBP3300 (CNCUPSLBP3300CAPTK.ppd)
    LBP3300

    Canon LBP3250 (CNCUPSLBP3250CAPTK.ppd)
    LBP3250

    Canon LBP3210 (CNCUPSLBP3210CAPTK.ppd)
    LBP3210

    Canon LBP3200 (CNCUPSLBP3200CAPTK.ppd)
    LBP3200

    Canon LBP3100/LBP3108/LBP3150 (CNCUPSLBP3150CAPTK.ppd)
    LBP3150/LBP3108/LBP3100

    Canon LBP3010/LBP3018/LBP3050 (CNCUPSLBP3050CAPTK.ppd)
    LBP3050/LBP3018/LBP3010

    Canon LBP3000 (CNCUPSLBP3000CAPTK.ppd)
    LBP3000

    Canon LBP2900 (CNCUPSLBP2900CAPTK.ppd)
    LBP2900

    Canon LBP-1210 (CNCUPSLBP1210CAPTK.ppd)
    LBP-1210

    Canon LBP-1120 (CNCUPSLBP1120CAPTK.ppd)
    LBP-1120

Please see the online manual about the install method and the concrete usage.


4. Auto startup setting procedure for ccpd daemon -------------------------------
When setting the Status Monitor to start automatically, ccpd daemon must be set
to start automatically as well.
Set ccpd daemon to start automatically in the following procedure.

<For a distribution with a /etc/rc.local file>
Log in as 'root' and add the '/etc/init.d/ccpd start' command to the
/etc/rc.local file.

<For a distribution with a /sbin/insserv command>
Log in as 'root', add the following comments to the third line in
/etc/init.d/ccpd, and execute the 'insserv ccpd' command.

### BEGIN INIT INFO
# Provides:          ccpd
# Required-Start:    $local_fs $remote_fs $syslog $network $named
# Should-Start:      $ALL
# Required-Stop:     $syslog $remote_fs
# Default-Start:     3 5
# Default-Stop:      0 1 2 6
# Description:       Start Canon Printer Daemon for CUPS
### END INIT INFO

<For a distribution with a /usr/bin/systemctl command> 
Log in as 'root', create a /etc/rc.local file in the editor, and add 
the following. 
  #!/bin/sh
  /etc/init.d/ccpd start

Next, execute the command below and update the version of the 
/erc/rc.d/rc.local file.
  # chmod 777 /etc/rc.d/rc.local


5. Cautions, Limitations, and Restrictions --------------------------------------

- When installing version 3.21 of the cndrvcups-common package, make sure you 
  install version 2.71 of the cndrvcups-capt package.

- When specifying multiple pages/copies for [Page Layout] in the [General]
  sheet to print a document created with StarSuite7/OpenOffice, due to a cause
  of operation by the CUPS module, settings are not correctly assigned to the
  multiple pages and output.

- PostScript files created with the number of copies specified in OpenOffice.org
  or StarSuite are affected not by the value specified by [Copies] in the 
  [cngplp] dialog box (the driver UI), but by the number of copies set when 
  creating the PostScript file.

- If settings are changed from the driver UI, during print processing, the
  printed result will reflect the changed settings.

- If [Brightness and Gamma] is specified in the [General] sheet from an
  application such as OpenOffice.org, GIMP, or Acrobat Reader v.5.0, the settings
  will be invalid.

- You cannot print a PDF document by directly specifying it from the desktop or
  command line. When printing a PDF document, it is recommended that you print
  it from Acrobat Reader or Adobe Reader.

- The maximum number of files that can be held in the print queue when printing
  is 500 according to CUPS specifications. Files queued after the 500th file will
  be ignored.

- When the paper size is specified from the application, the specified contents
  will not be valid. The value specified for [Page Size] in the [General] sheet
  in the printer driver screen will be reflected when printing.

- If you are using SUSE LINUX Professional 9.3, the driver UI may display
  unintelligible characters. You can solve this problem using the following
  method.
  1) Log in as 'root'.
  2) Execute the following command to change the GTK+ environment settings.
     # cd /etc/
     # ln -s opt/gnome/gtk ./

- If you are using SUSE LINUX Professional 9.3, a warning may occur when you
  activate the driver UI. You can solve this problem using the following method.
  1) Open [K Menu] -> [Control Center].
  2) Select [Appearance & Themes].
  3) Select [Colors].
  4) Deselect [Apply colors to non-KDE applications].
  5) Close [Control Center].

- If you are using LBP9100Cdn, LBP7210Cdn, LBP7200 series, LBP7018C, LBP7010C,
  LBP6310dn, LBP6300dn, LBP6300n, LBP6200, LBP6020, LBP6018, LBP6000, LBP5300,
  LBP5100, LBP5050 series, LBP5000, LBP3500, LBP3310, LBP3300, LBP3250,
  LBP3150, LBP3108, LBP3100, LBP3050, LBP3018, or LBP3010, blank paper is not
  output according to Glue Code specifications, even if the print job
  includes blank pages.
  The setting does not become effective even after setting [Use Skip Blank
  Pages Mode] in the [Finishing Details] dialog box to [Off] or specifying the
  printer setting not to use the Skip Blank Pages mode from the command line.

- If you are using LBP5300 in a network environment, the version of the firmware
  of the network board needs to be 1.10 or later, otherwise the network board
  does not operate properly.
  Download the latest update file from the Canon website and update the firmware.

- If you are using LBP5000, LBP3500 or LBP3300 with NB-C1 installed in a network
  environment, the version of the firmware of the network board needs to be 1.30
  or later, otherwise the network board does not operate properly.
  Download the latest update file from the Canon website and update the firmware.

- If you are using LBP3310 with NB-C2 installed in a network environment, the
  version of the firmware of the network board needs to be 1.30 or later,
  otherwise the network board may not operate properly. Download the latest
  update file from the Canon website and update the firmware.

- If you use the Cancel Job key on the printer unit to cancel jobs, the jobs 
  from CUPS may not be cleared depending on the data size. In this case, 
  delete the jobs using the CUPS interface.

- If you cannot browse the IP address of localhost, you cannot start Status
  Monitor.
  Modify "/etc/hosts" so that you can browse the IP address of localhost.

- If you have connected the printer using a USB cable in the environment in 
  which the HAL daemon runs on Fedora Core, delete the registered printer entry 
  created by the HAL daemon with the printer name once, and then perform the 
  registration operation for the printer.

- If you are using CUPS 1.2.x for the printing system, the printer may not
  operate properly when printing banner pages.
  Before you print banner pages, replace the printing system with CUPS 1.1.x.

- If you are using the following distributions, you may not be able to install
  the printer driver successfully because "libstdc++.so.5" is not installed by
  default.
  In this case, perform the additional installation of the package.
  - For Fedora Core 4, Fedora Core 5, Fedora Core 6, Fedora 7, Fedora 8,
    Fedora 9, Fedora 10, Fedora 11, Fedora 12, Fedora 13, Fedora 14,
    RedHat Enterprise Linux 5.1, and CentOS 5.3
    -> Install the package (compat-libstdc++-33).
  - For Ubuntu 7.10, Ubuntu 8.04, Ubuntu 8.10, Ubuntu 9.04, Ubuntu 9.10,
    Ubuntu 10.04, Ubuntu 10.10, Debian GNU/Linux 4.0, and Debian GNU/Linux 5.0
    -> Obtain the package (gcc-3.3-base or libstdc++5) from
       "http://lug.mtu.edu/ubuntu/pool/main/g/gcc-3.3/" to install it.
       Reference Information: http://ubuntuforums.org/showthread.php?t=674100
  - For Mandriva 2008 and Mandriva 2008 Spring
    -> Obtain the package (libstdc++5) from the standard mirror server etc. to
       install it.
  - For openSUSE 11.1
    -> Install the package (libstdc++33-.3.3-7.5.i586).

- If you are using SUSE Linux 9.3 or SUSE Linux 10.0, and are printing from
  the [Print] dialog box of Mozilla or FireFox, because the multiple copies
  setting is not enabled, you can print only one copy regardless of how many
  copies you have specified.
  This problem can be solved by changing the following line in the file
  "/etc/cups/mime.convs".
  [Before change]
    application/mozilla-ps application/postscript 33 pswrite
  [After change]
    application/mozilla-ps application/postscript 33 pstops

- When performing banner printing in Fedora 8 or Fedora 9, if you specify a
  setting other than [none] for [End] under [Banner] in the [General] sheet,
  the print queue will stop.

- If you are using Fedora 9, restarting the CCPD daemon may stop the kernel.
  You can avoid this problem by updating the kernel to 
  "kernel-2.6.25.14-108.fc9".

- If you are using Fedora 11 and print with the print queue stopped after
  canceling a job, the job is suspended. In this case, click the [Maintenance]
  button in Printers in the CUPSWeb interface and select [Resume Printer] to
  perform the [pending since] job again.
  If you cannot find the [Maintenance] button, you can select [Resume Printer]
  by selecting [Pause Printer].

- If you are using openSUSE 10.2 or SLED10SP1, which includes Ghostscript
  version 8.15.3, you may not be able to print some documents. To solve this
  problem, install another version of Ghostscript.

- If you are using openSUSE 11.0 with Ghostscript version 8.6.x, printing from
  Evince, GIMP, or other applications may take time.

- If you are using Adobe Reader 7.0.x, and modify such settings as Paper Size,
  Paper Source, Duplex Printing, etc. in the print dialog window, these options
  are automatically added to the printer command. However, these settings will
  not work because they cannot be recognized as command options. To solve this
  problem, use "-o" to separate each command options.
     [before] -o InputSlot=Manual,Duplex=DuplexNotumble
     [after]  -o InputSlot=Manual -o Duplex=DuplexNoTumble

- When printing PDF files using Adobe Reader 8, there may be instances where
  some image data is not printed.
  This problem may be solved by printing using Adobe Reader 7 or Adobe Reader 9,
  or setting Level 3 in the PostScript options.

- When performing 2-sided printing with Adobe Reader 8.1.2, if you specify
  [ON (Short-edged Binding)] for [Duplex Printing] in the print properties for
  Adobe Reader 8.1.2, the document will be printed on both sides with long-edged
  binding.
  This problem can be avoided by printing the document using the printer driver
  UI.

- If you are using Vine Linux 3.1, you may take time to print from Adobe Reader
  7.0.9 or may not be able to print some documents.

- When printing PDF files containing Japanese characters from the command line
  in Vine Linux 4.1, there may be instances where Ghostscript terminates
  unexpectedly, causing printing to stop.
  This problem can be avoided by printing PDF files using Adobe Reader.

- When printing PDF files from Adobe Reader 8 in Vine Linux 4.1, there may be
  instances where Ghostscript terminates unexpectedly, causing the print queue
  to stop.
  This is caused by Ghostscript (7.07) not being able to analyze PS files
  created by Adobe Reader 8, and consequently terminating prematurely, thereby
  stopping the filtering process.
  This problem can be avoided by using Adobe Reader 7.

- When printing text files in landscape orientation in Vine Linux 4.1,
  Vine Linux 4.2, Fedora 8, Fedora 9, or RedHat Enterprise Linux v.5, there may
  be instances where the text file is printed in portrait orientation with some
  of the print data not being printed on the page. This is caused by the CUPS
  filter employed by the distribution you are using creating a PS command that
  is already set to portrait.
  Also, some of the functions provided in the CUPS standard filter "texttops"
  may not operate correctly.
  This problem can be avoided by changing the CUPS filter name specified in the
  "text/plain" entry line in the CUPS setting file "mime.convs" to the CUPS
  standard filter "texttops". This will result in Japanese characters being
  misprinted, therefore when printing Japanese characters, it is necessary to
  print a PS command created with a text editor or text/PostScript conversion
  program such as paps.

- If you specify Paper Source settings in the print dialog of an application
  such as Writer of OpenOffice.org, the settings made from the application are
  overridden by the printer driver UI settings. To print from the desired
  Paper Source, specify the Paper Source from the printer driver UI beforehand,
  or print from the command line.

- If you are using Debian GNU/Linux 4.0, a PPD file error may occour when you
  register the printer (PPD) with the print spooler. To solve this problem,
  use "-P (full path to the ppd)" instead of "-m" when you specify the ppd
  using the command line.
    Example: /usr/sbin/lpadmin -p LBP5000
              -P /usr/share/cups/model/CNCUPSLBP5000CAPTK.ppd
              -v ccp://localhost:59687 -E

- If you are using Debian GNU/Linux 4.0 r6, and attempt to print a text file
  using the printer driver UI when EUC-JP is set as the locale, printing will
  fail.
  This problem can be solved by printing a PS command created with a text editor
  or text/Postscript conversion program such as paps.

- If you are using Debian GNU/Linux 5.0.2, the gs-esp module is required to
  install the common module.
  You can install the gs-esp module by executing the following command.
    # apt-get install gs-esp

- If you are using Ubuntu 7.10, you may fail to print because it introduces
  security software called AppArmor.
  As the workaround, disable the AppArmor CUPS profile by running
  sudo aa-complain cupsd to enable printing.
  For more details, see Ubuntu 7.10 Release Notes.

- If you are using Fedora 19, Fedora 20, Fedora 21, Ubuntu 8.10, Ubuntu 9.04, 
  Ubuntu 9.10, Ubuntu 10.04, Ubuntu 10.10, Ubuntu 11.04, Ubuntu 11.10, 
  Ubuntu 12.04, Ubuntu 14.04, and Ubuntu 14.10, the printer will print with 
  the default paper output method, regardless of whether you have specified 
  the paper output method.
  This problem can be solved by changing the output paper method setting from
  the CUPS printer settings (Web).

- If you are using Ubuntu 8.10, specifying reverse order for printing does not
  affect the print result.
  This problem can be solved by updating CUPS.

- If you are using Ubuntu 8.10, Ubuntu 9.04, Ubuntu 9.10, Ubuntu 10.04,
  Ubuntu 10.10, Ubuntu 11.04, Ubuntu 11.10, Ubuntu 12.04, Ubuntu 14.04, and 
  Ubuntu 14.10, when printing PDF data or PS data, brightness and gamma 
  correction settings may not affect the print result.

- If you are using Ubuntu 7.04, Ubuntu 7.10, Ubuntu 8.04, Ubuntu 8.10,
  Ubuntu 9.04, Debian GNU/Linux 3.1, Debian GNU/Linux 4.0, or
  Debian GNU/Linux 5.0, the libcupsys2 library is required to install
  the common module.
  You can install the libcupsys2 library by executing the following command.
    # apt-get install libcupsys2

- If you are using Ubuntu 9.04 and update the CUPS version to
  "1.3.9-17ubuntu3.2", printing will fail due to improper PS data.
  You can avoid this problem by downgrading the CUPS version to
  "1.3.9-17ubuntu3.1".
  <Downgrading with the apt-get command>
    - Execute the following command.
        # apt-get install cups=1.3.9-17ubuntu3.1

- If you are using Ubuntu 9.04, Ubuntu 9.10, Ubuntu 10.04, Ubuntu 10.10,
  Ubuntu 11.04, Ubuntu 11.10, Ubuntu 12.04, Ubuntu 14.04, Ubuntu 14.10, 
  Fedora 11, Fedora 12, Fedora 13, Fedora 14, Fedora 15, Fedora 16, 
  Fedora 17, Fedora 18, Fedora 19, Fedora 20, or Fedora 21, and print 
  banner pages, the specified number of banner pages are printed.

- When printing PDF files from Adobe Reader in Mandriva, regardless of the
  version being used, there may be instances where Ghostscript terminates
  unexpectedly, causing the print queue to stop.
  This is caused by Ghostscript (8.60) not being able to analyze PS commands
  created using PS files for which security settings have been specified, and
  consequently terminating prematurely, thereby stopping the filtering process.
  This problem can be avoided by not printing PDF files that have security
  settings using Adobe Reader.

- If you are using Mandriva One 2008 Spring or Mandriva 2008 PowerPack with CUPS
  version 1.3.6, unintended print results may occur even when printing with
  standard CUPS print functions.
  This problem can be solved by updating CUPS.

- If you want to use multiple printers with the same device path (such as
  /dev/usb/lp0) on a USB connection, exit the ccpd daemon, and then add a
  printer when you switch the connection.
  If you do not exit the ccpd daemon, you may not be able to obtain appropriate
  printout results.

- If 15 or more characters are specified for the host name of Linux, the printer
  status may not display properly in Status Monitor.

- If you are using printers of the same model with one computer, and one is
  connected via USB and another is connected via network, the printer status may
  not display properly in Status Monitor.

- If your version of Ghostscript is 8.6x, you may not be able to print some
  documents.

- If you are using CentOS 5.3, you cannot print the number of copies as you
  specified in Evidence.
  You can solve this problem by printing from other PDF viewers such as
  Adobe Reader or using the following methods.
  1) Set the number of copies to 1 and select a PS command for the output
     destination in Evince to output a file.
  2) Print the PS command output as a file after specifying the number of
     copies in cngplp.

- When updating and installing the printer driver from version 1.90 to version
  2.70 or later, you need to re-register the printer registered before updating and
  installing the printer driver.

- When updating and installing the printer driver of the deb package from
  version 1.90 or earlier to version 2.70 or later, the message to check if you install
  "ccpd.conf" included in the installation package may be displayed in the
  console.
  In this case, install "ccpd.conf" included in the installation package.

- Depending on the version of GTK (GIMP Toolkit), some characters may be
  unintelligible when displayed on the screen, but this does not indicate
  a problem with the functions and values set. Redraw the corresponding text
  area to solve this problem.

- If you are using Fedora 12 or Ubuntu 9.10, when you change the default options
  from the CUPS Web interface, the default values will be saved even if there is
  a conflict between the settings for each function. Also, once the settings are
  saved with a conflict, you cannot save the settings again even if you use the
  Web interface to change them to the correct values where there is no conflict.
  If you display the [cngplp] dialog box in this situation, an invalid operation
  may occur.
  You can use the following methods to solve this problem:
    [Method 1] Fedora 12 (32-bit/64-bit) and Ubuntu 9.10
      Re-register the printer that performed the invalid operation.
    [Method 2] Fedora 12 (32-bit/64-bit)
      Execute the following command to update CUPS:
    <For Fedora 12 (32-bit)> # yum update cups.i686
    <For Fedora 12 (64-bit)> # yum update cups.x86_64

- If you are using this driver in a 64-bit environment, and update a version
  2.20 driver to version 2.30 or later, errors  may occur when printing.
  This problem can be solved by uninstalling (rpm -e [driver]) then
  re-installing (rpm -i [driver]) the new driver.
  Alternatively, you can uninstall the old driver (rpm -e [driver]) instead
  of updating it, then install the new driver (rpm -i [driver]).

- If you are using the 32-bit or 64-bit version of Fedora 13, Fedora 14,
  Fedora 15, Fedora 16, Fedora 17, Fedora 18, Fedora 19, Fedora 20, Fedora 21, 
  and print a TIFF or JPEG file from the driver UI or command line, the printed 
  image may be broken up.
  This problem can be solved by outputting the file as a PostScript file from
  an application such as GIMP, then printing from the command line by typing
  the PostScript command used to output the file after [cngplp].

- If you are using Fedora 12, Fedora 13, Fedora 14, Fedora 15, Fedora 16, 
  Fedora 17, Fedora 18, Fedora 19, Fedora 20, or Fedora 21, even if you specify 
  the brightness and gamma settings from the driver UI or the command line, 
  these settings are not applied to the printed result from the second page 
  onward. This is due to these functions not being enabled because Ghostscript 
  does not correctly recognize the PostScript data created by the application.

- About printing from Fedora 15/Fedora 16/Fedora 17/Fedora 18/Fedora 19/
  Fedora 20/Fedora 21
  When printing portrait orientation PDF data by default from cngplp in
  Fedora 15/Fedora 16/Fedora 17/Fedora 18/Fedora 19/Fedora 20/Fedora 21, 
  images may lie outside the paper (a landscape orientation image is printed 
  on portrait orientation paper).
   [Avoidance plan 1]
    Print from an application such as Adobe Reader.
   [Avoidance plan 2]
    Convert PDF data to PS data from an application such as Adobe Reader, and
    then print it from cngplp.

- About brightness settings in Ubuntu 11.04/Ubuntu 11.10/Ubuntu 12.04/
  Ubuntu 14.04/Ubuntu 14.10/Fedora 15/Fedora 16/Fedora 17/Fedora 18/Fedora 19/
  Fedora 20/Fedora 21
  If you specify brightness 9 to 0 to print in Ubuntu 11.04/Ubuntu 11.10/
  Ubuntu 12.04/Ubuntu 14.04/Ubuntu 14.10/Fedora 15/Fedora 16/Fedora 17/
  Fedora 18/Fedora 19/Fedora 20/Fedora 21, the brightness setting is not 
  enable, print results are equivalent to when specifying brightness 100.

- About default paper sizes in Ubuntu 10.10, Ubuntu 11.04, Ubuntu 11.10,
  Ubuntu 12.04, Ubuntu 14.04, Ubuntu 14.10, Fedora 14, Fedora 15, Fedora 16, 
  Fedora 17, Fedora 18, Fedora 19, Fedora 20, Fedora 21
  When registering the printer for U.S., the default paper size may be A4 in
  Ubuntu 10.10, Ubuntu 11.04, Ubuntu 11.10, Ubuntu 12.04, Ubuntu 14.04, 
  Ubuntu 14.10, Fedora 14, Fedora 15, Fedora 16, Fedora 17, Fedora 18, 
  Fedora 19, Fedora 20, Fedora 21.
  You can avoid this circumstance by registering the printer using the following
  procedures.
   [Avoidance plan 1]
    Register "-P" instead of "-m" to the option which specifies the PPD files
    for the lpadmin command. (When specifying PPD files with "-P", specify an
    absolute or relative path for the PPD files.)
     Example: # /usr/sbin/lpadmin   -p [Printer registration name]
              -P [PPD file path] -v lpd: [Device URI] -E
   [Avoidance plan 2]
    Add "DefaultPaperSize Auto" to "/etc/cups/cupsd.conf", and then restart CUPS
    to register the printer.

- About TIFF or JPEG image printing
  When printing TIFF or JPEG images from cngplp or command line, the printed
  images may be divided on multiple pages.
   [Avoidance plan]
    You can avoid this circumstance by printing a PS command which is output
    using cngplp or command line after outputting PostScript files from the
    applications such as GIMP.

- Printing from Ubuntu 11.10/Ubuntu 12.04/Ubuntu 14.04/Ubuntu 14.10
  When you print a PDF file using cngplp from Ubuntu 11.10/Ubuntu 12.04/
  Ubuntu 14.04/Ubuntu 14.10, the document size print option may be invalid and 
  it may be changed and printed to a document size embedded to the PDF file. 
  In this case, print the PDF file from an application such as Acrobat Reader.

- Paper Size in Ubuntu 11.10/Ubuntu 12.04/Ubuntu 14.04/Ubuntu 14.10
  When manipulating the combo box of cngplp on Ubuntu 11.10/Ubuntu 12.04/
  Ubuntu 14.04/Ubuntu 14.10, you may not be able to work on UIs if you specify 
  items when a slider gauge is shown. In this case, enter an ESC key.

- Communication with USB connected printer from Ubuntu 11.10
  In Ubuntu 11.10, the communication with a USB connected printer may not be
  established if "usblp" is not lauched when the OS is launched. Follow the
  procedures below to avoid the problem.
   [Avoidance plan 1]
    When launching the OS, execute the command shown below to read the "usblp"
    module.
     # sudo modprobe usblp
   [Avoidance plan 2] 
    Remove the "blacklist usblp" line from the /etc/modprobe.d/blacklist-cups-
    usblp.conf file, and cancel the setting to inhibit the "usblp" module
    reading when the OS is launched.

- You can register up to 16 printers to a single PC with this printer driver.

- About printing from Ubuntu 12.04/Ubuntu 14.04/Ubuntu 14.10 "LibreOffice"
  If LibreOffice for Ubuntu is used to print Windows Office-format (*.doc, etc.)
  data, the printing result may be broken up or printing may not be possible.
  This is due to Ghostscript not correctly recognizing the PostScript data
  created by the application.

  [Avoidance plan 1]
   After converting Windows Office format (*.doc, etc.) to LibreOffice format
   (*.odt, etc.), open the Print dialog box, select an option for [Printer
   Language type] other than [PDF], and then print.
  [Avoidance plan 2]
   This problem can be solved by first selecting an option for [Printer
   Language type] other than [PDF] from LibreOffice, then outputting the file
   as a PostScript file, then printing from the command line by typing the
   PostScript command used to output the file after [cngplp].

- About restarting the ccpd for Ubuntu 12.04/14.04/14.10
  In Ubuntu 12.04/14.04/14.10, the ccpd may not restart even if the following 
  command is executed.
  In this case, execute the command again.
   # /etc/init.d/ccpd restart

  If you continue by entering the following commands, the ccpd may not restart.
   # /etc/init.d/ccpd stop
   # /etc/init.d/ccpd start
  In this case, first enter the ccpd stop command, and then wait a little 
  before entering the ccpd start command.

- If you are using Ubuntu 12.04, and attempt to continuously print the same 
  data, the data may not print correctly after the second time.
  You can solve this problem by updating CUPS with the following commands.
   # apt-get install cups
   # apt-get install libcups2

- If you are using Ubuntu 14.04 or Fedora 19/20/21, and select "standard," 
  "classified," "secret," "confidential," "topsecret," or "unclassified" in 
  the banner page print settings from the [cngplp] dialog box or the 
  command line, the selection is not reflected in the printed result.

- About other jobs overriding banner printing with Ubuntu 14.04/14.10 and 
  Fedora 19/20/21
  When another job is sent to the device while it is printing a banner, the 
  device might priority-print the job between printing of the banner page and 
  the main text, depending on the timing when the device receives the job.

- If you are printing an image included in a PDF file, you may not be able to 
  print it correctly depending on the program pdftops uses.
  You can solve this problem by changing the program that pdftops uses with the 
  following command.

  <If you are using ghostscript pdftops>
   # lpadmin -p [registered printer name] -o pdftops-renderer-default=pdftops

  <If you are using poppler pdftops>
   # lpadmin -p [registered printer name] -o pdftops-renderer-default=gs

- If you print a TIFF image file from the [cngplp] dialog box or the command 
  line, the print result may be blacked out, depending on the image.
  [Method 1]
    You can overcome this problem by printing from an application such as 
    GIMP etc.
  [Method 2]
    You can overcome this problem by outputting the file as a PostScript file, 
    then printing the output PostScript file from the [cngplp] dialog box.

- If you are using Ubuntu 14.04 or 14.10, unintelligible characters may be 
  printed if you print text data including multi-byte characters from the 
  [cngplp] dialog box or command line. You can solve this problem by printing 
  from a text editor such as gedit.

- If you print a PDF image file from the [cngplp] dialog box or command line, 
  the print result may be blacked out, depending on the image.
  [Method]
    If you are using an environment in which you can use Adobe Reader 9, you 
    can solve this problem by selecting [Let printer determine colors] or 
    [Print As Image] in the [Advanced Print Setup] dialog box when printing.

- Regarding printer registration in Fedora 19 and Ubuntu 14.10
  If you use the "-m" option when creating a printer queue using the lpadmin 
  command from Fedora 19 or Ubuntu 14.10, the queue may not be displayed in the 
  [cngplp] dialog box with general user privileges.

  [Method]
  Specify "-P" instead of "-m" as the PPD file specifying option in the 
  lpadmin command when registering.
  * If you specify the PPD with "-P", specify an absolute path or relative 
    path as the path to the specified PPD file.

    Example:
    # /usr/sbin/lpadmin -p [printer name to be registered] -P [PPD file path] 
      -v lpd:[device URI] -E

- About deb package update installation
  When installing an update from version 2.60 or earlier to version 2.70 or 
  later, competing files cause an install error.
  Specify the option below to install the update.
   # dpkg -i --force-overwrite <driver module filename>

- About starting the ccpd
  When starting the ccpd daemon, the following errors may be displayed.
  Starting ccpd (via systemctl):    Failed to start ccpd.service:
  Unit ccpd.service failed to load: No such file or directory.

  If an error occurs, execute the following command before starting the 
  ccpd daemon.
   # systemctl daemon-reload

- About printing text from Fedora 21
  When the length of one line of text exceeds the width of the paper, a line 
  break is made according to the width of the paper, however, the text after 
  the line break may be printed with squeezed character spacing.
  [Avoidance plan]
   You can avoid this problem by printing from gedit or other text editor.

- If you are using Fedora, you may not be able to install the driver due to a 
  lack of necessary packages. If this happens, you can solve the problem by 
  adding packages using the following commands.

  <For Fedora 10(64-bit)> 
   # yum install glibc.i386
   # yum install libxml2.i386
   # yum install compat-libstdc++-33-3.2.3-64.i386

  <For Fedora 11(64-bit)>
   # yum install glibc.i586
   # yum install libxml2.i586
   # yum install compat-libstdc++-33-3.2.3-64.i586

  <For Fedora 12/13/14(64-bit)>
   # yum install glibc.i686
   # yum install libgcc.i686
   # yum install libstdc++.i686
   # yum install compat-libstdc++-33-3.2.3-64.i686
   # yum install popt.i686
   # yum install libxml2.i686

  <For Fedora 15/16/17(64-bit)>
   # yum install glibc.i686
   # yum install libgcc.i686
   # yum install libstdc++.i686
   # yum install popt.i686
   # yum install libxml2.i686

  <For Fedora 18/19/20/21(64-bit)> 
   # yum install pangox-compat 
   # yum install glibc.i686 *
   # yum install libgcc.i686 *
   # yum install libstdc++.i686 *
   # yum install popt.i686 *
   # yum install libxml2.i686 *

   * There may be cases where installation of the 64-bit library of the same 
     name (newest version) is required.
     Example:
     If the library installation fails with the command "yum install 
     glibc.i686," this may be remedied by executing "yum install glibc.i686" 
     after installing 64-bit glibc library with the command "yum install glibc".

  <For Fedora 18/19/20/21(32-bit)>
   # yum install pangox-compat

- If you are using Ubuntu, when installing with the default settings, you may 
  not be able to install the driver due to a lack of necessary libraries. 
  You can solve the problem by installing libraries using the following 
  commands.

  <For Ubuntu 12.04/14.04/14.10(32-bit)>
   # apt-get install libglade2-0

  <For Ubuntu 12.04(64-bit)>
   # apt-get install libglade2-0
   # apt-get install ia32-libs
   # apt-get install libpopt0:i386

  <For Ubuntu 14.04/14.10(64-bit)>
   # apt-get install libglade2-0
   # apt-get install libxml2:i386
   # apt-get install libstdc++6:i386
   # apt-get install libpopt0:i386

- To use the printer driver, Ghostscript which includes the common API is required.
  Before installing the printer driver, check that Ghostscript is installed.
  You can check using the following command in terminal software such as
  GNOME Terminal.
    % gs -h | grep opvp
  If opvp or oprp is displayed, Ghostscript which includes the common API
  is installed. If nothing is displayed, see the following URL to obtain Ghostscript.
  http://opfc.sourceforge.jp/index.html.en


6. Appendix -----------------------------------------------------------------
Following list shows licensed modules.

Schedule 1

c3pldrv
libc3pl.so.0.0.1
libcaepcm.so.1.0
libcaiousb.so.1.0.0
libcaiowrap.so.1.0.0
libcanon_slim.so.1.0.0
libColorGear.so.0.0.0
libColorGearC.so.0.0.0
CANSRGBA.ICC
CNZ005.ICC
CNZ006.ICC
CNZ007.ICC
CNZ008.ICC
CNZ055.ICC
ccpd.conf
ccpd (daemon)
captdrv
captfilter
captmon
captmon2
captmonlbp3300
captmonlbp5000
captmoncnab6
captmoncnab7
captmoncnab8
captmoncnab9
captmoncnaba
captmoncnabb
captmoncnabc
captmoncnabd
captmoncnabe
captmoncnabf
captmoncnabg
captmoncnac5
captmoncnac6
captmoncnac8
captmoncnac9
captmoncnaca
captmoncnacb
captmoncnacc
captmoncnacd
libcaiocaptnet.so.1.0.0
libcaptfilter.so.1.0.0
libcnaccm.so.1.0
libcncaptnpm.so.2.0.1
CNC610A.ICC
CNC610B.ICC
CNC710A.ICC
CNC710B.ICC
CNC711A.ICC
CNC711B.ICC
CNC810A.ICC
CNC810B.ICC
CNC910A.ICC
CNC910B.ICC
CNCA10A.ICC
CNCA10B.ICC
CNCB10A.ICC
CNCB10B.ICC
CNCC10A.ICC
CNCC10B.ICC
CNCD11A.ICC
CNCD11B.ICC
CNCE10A.ICC
CNCE10B.ICC
CNCF10A.ICC
CNCF10B.ICC
CNCG10A.ICC
CNCG10B.ICC
CNCH10A.ICC
CNCH10B.ICC
CNCI10A.ICC
CNCI11B.ICC
CNCJ10A.ICC
CNCJ10B.ICC
CNL610A.ICC
CNL610B.ICC
CNL611A.ICC
CNL611B.ICC
CNL760A.ICC
CNL760B.ICC
CNL810A.ICC
CNL810B.ICC
CNL820A.ICC
CNL820B.ICC
CNL821A.ICC
CNL821B.ICC
CNL960A.ICC
CNL960B.ICC
CNL980A.ICC
CNL980B.ICC
CNLA60A.ICC
CNLA60B.ICC
CNLA80A.ICC
CNLA80B.ICC
CNLB10A.ICC
CNLB10B.ICC
CNLC10A.ICC
CNLC10B.ICC
CNLD10A.ICC
CNLD10B.ICC
CNLD80A.ICC
CNLD80B.ICC
CNLE60A.ICC
CNLE60B.ICC
CNLF10A.ICC
CNLF10B.ICC
CNLG10A.ICC
CNLG10B.ICC
CNLH60A.ICC
CNLH60B.ICC
CNLH80A.ICC
CNLH80B.ICC
CNLI10A.ICC
CNLI10B.ICC
CnAC076D.DAT
CnAC0999.DAT
CnAC25C8.DAT
CnAC2849.DAT
CnAC29A9.DAT
CnAC4739.DAT
CnAC7AA5.DAT
CnACB5C9.DAT
CnACB81B.DAT
CnACB848.DAT
CnACD891.DAT
CnACE599.DAT
CnACE8E8.DAT
CnACF0F1.DAT
CnAC_04A.DAT
CnAC_09A.DAT
CnAC_14A.DAT
CnAC_17A.DAT
CnAC_20A.DAT
CnAC_22A.DAT
CnAC_23A.DAT
CnAC_31A.DAT
CnAC_33A.DAT
CnABFINK.DAT
CnAC8INK.DAT
CnAC9INK.DAT
CnACAINK.DAT
CnACBINK.DAT
CnACCINK.DAT
CnACDINK.DAT
ccpd (startup script for the daemon)
ccpdadmin
msgtablelbp3300.xml
msgtablelbp5000.xml
msgtablecnab6.xml
msgtablecnab7.xml
msgtablecnab8.xml
msgtablecnab9.xml
msgtablecnaba.xml
msgtablecnabb.xml
msgtablecnabc.xml
msgtablecnabd.xml
msgtablecnabe.xml
msgtablecnabf.xml
msgtablecnabg.xml
msgtablecnac5.xml
msgtablecnac6.xml
msgtablecnac8.xml
msgtablecnac9.xml
msgtablecnaca.xml
msgtablecnacb.xml
msgtablecnacc.xml
msgtablecnacd.xml
msgtable.xml
msgtable2.xml
CNAB1CL.BIN
CNAB7CL.BIN
CNABBCL.BIN
CNABBCLS.BIN
CNABECL.BIN
CNABGCL.BIN
CNAC4CL.BIN
CNAC5CL.BIN
CNAC6CL.BIN
CNAC8CL.BIN
CNAC8CR.BIN
CNAC8DH.BIN
CNAC9CL.BIN
CNAC9CLS.BIN
CNAC9CR.BIN
CNAC9DH.BIN
CNACACL.BIN
CNACACR.BIN
CNACADH.BIN
CNACBCL.BIN
CNACCCL.BIN
CNACCCR.BIN
CNACCDH.BIN
CNACDCL.BIN
CNACDCR.BIN
CNACDDH.BIN
cnab6cl.bin


Schedule 2

cnusb
cngplp
cnjatool
cngplp.mo
cngplp.glade
ccp
pstocapt
pstocapt2
pstocapt3
captstatusui
captstatusui.mo
libuictlcapt.la
libuictlcapt.so.1.0.0
libuictlcapt.1.0.mo
cngplp_capt.glade
func_config_capt.xml
*.res
*.ppd


Schedule 3

buflist.h
buftool.h
libbuftool.a
libcanoncapt.la
libcanoncapt.so.1.0.0
libcanonc3pl.so.1.0.0


=================================================================================
Support
=================================================================================
This Software and Related Information are independently developed by Canon and 
distributed by your Canon local company. Canon (as a manufacturer of printers 
supporting this Software and Related Information) and your Canon local company 
(as a distributor), will not respond to any inquiries about this Software or 
Related Information. However, any inquiries about printer repair, consumable 
supplies, and devices should be directed to your Canon local company.
=================================================================================
                                                        Copyright CANON INC. 2013

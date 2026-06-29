#include <math.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

/*
  palette consists of:

  1. RGB mixes
  2. 10-step pure R values
  3. 10-step pure G values
  4. 10-step pure B values
  5. 10-step B/W
  6. an extra pure black

  Try to find the palette entry that's closest to the desired colour.

  TODO: Check if colour may be closer to a high-precision R/G/B/BW entry
*/
uint8_t getClosestColourValue (double rIntensity, double gIntensity, double bIntensity) {
  uint8_t r = round (5 * rIntensity);
  uint8_t g = round (5 * gIntensity);
  uint8_t b = round (5 * bIntensity);

  fprintf (stderr,
    "Intensity: "
    "%lf|"
    "%lf|"
    "%lf\n",
    rIntensity, gIntensity, bIntensity
  );
  fprintf (stderr,
    "Newval: "
    "%u|"
    "%u|"
    "%u\n",
    r, g, b
  );

  if ((r + g + b) == 0) {
    // entry stolen by high-precision R palette, point at other index instead
    return 0xFF;
  } else {
    return
      ((6 * 6 * 6) - 1) // lowest-intensity value (except see above)
      - (
        b
        + (g * 6)
        + (r * 6 * 6)
      );
  }
}

bool readUntilNextElement (FILE* ppmFile) {
  char buffer = '\0';
  bool inComment = false;

  while (true) {
    if (fread (&buffer, sizeof (char), 1, ppmFile) != 1) return false;
    switch (buffer) {
      case ' ':
      case '\t':
        break;

      case '\r':
      case '\n':
        if (inComment) {
          inComment = false;
        }
        break;

      case '#':
        inComment = true;
        break;

      default:
        if (!inComment) {
          fseek (ppmFile, -1, SEEK_CUR);
          return true;
        }
    }
  }
}

/* magic number of binary PPM: P6 */
char binaryPpmMagic[] = "P6";

int main (int argc, char** argv) {
  int ret = 0;
  FILE* ppmFile;
  char buffer[8];
  unsigned int width, height, depth;
  uint8_t x, y, r, g, b, paletteEntry;
  long startPpmPixelData;

  if (argc != 2) {
    printf ("Usage: /path/to/image.ppm\n");
    goto end;
  }

  fprintf (stderr, "Opening PPM file.\n");
  ppmFile = fopen (argv[1], "rb");
  if (ppmFile == NULL) goto fail;
  fprintf (stderr, "PPM file %s opened.\n", argv[1]);

  fprintf (stderr, "Reading magic number.\n");
  if (fread (buffer, sizeof (char), 2, ppmFile) != 2) goto fail;
  if (memcmp (buffer, binaryPpmMagic, 2) != 0) goto fail;
  fprintf (stderr, "Magic number %s found.\n", binaryPpmMagic);

  fprintf (stderr, "Reading image width.\n");
  if (!readUntilNextElement (ppmFile)) goto fail;
  if (fscanf (ppmFile, "%u", &width) != 1) goto fail;
  fprintf (stderr, "Width: %u\n", width);

  fprintf (stderr, "Reading image height.\n");
  if (!readUntilNextElement (ppmFile)) goto fail;
  if (fscanf (ppmFile, "%u", &height) != 1) goto fail;
  fprintf (stderr, "Height: %u\n", height);

  fprintf (stderr, "Reading colour depth.\n");
  if (!readUntilNextElement (ppmFile)) goto fail;
  if (fscanf (ppmFile, "%u", &depth) != 1) goto fail;
  fprintf (stderr, "Depth: %u\n", depth);
  if (depth > 0xFF) {
    fprintf (stderr, "Error: Not handling bit depth >= 16.\n");
    goto fail;
  }

  if (!readUntilNextElement (ppmFile)) goto fail;
  startPpmPixelData = ftell (ppmFile);

  printf ("%02X%02X\n", width, height);

  /* Grid 1: Normal icon */
  for (y = 0; y < height; ++y) {
    for (x = 0; x < width; ++x) {
      if (fread (&r, sizeof (uint8_t), 1, ppmFile) != 1) goto fail;
      if (fread (&g, sizeof (uint8_t), 1, ppmFile) != 1) goto fail;
      if (fread (&b, sizeof (uint8_t), 1, ppmFile) != 1) goto fail;

      fprintf (stderr,
        "Original RGB: "
        "%03u|"
        "%03u|"
        "%03u\n",
        r, g, b
      );

      paletteEntry = getClosestColourValue (
        ((double)r) / depth,
        ((double)g) / depth,
        ((double)b) / depth
      );
      printf ("%02X", paletteEntry);
    }
    printf ("\n");
  }

  printf ("\n");

  /* Grid 2: ? */
  fseek (ppmFile, startPpmPixelData, SEEK_SET);
  for (y = 0; y < height; ++y) {
    for (x = 0; x < width; ++x) {
      printf ("%02X", 255);
      /*
      if (fread (&r, sizeof (uint8_t), 1, ppmFile) != 1) goto fail;
      if (fread (&g, sizeof (uint8_t), 1, ppmFile) != 1) goto fail;
      if (fread (&b, sizeof (uint8_t), 1, ppmFile) != 1) goto fail;

      paletteEntry = getClosestColourValue (
        ((double)r) / depth,
        ((double)g) / depth,
        ((double)b) / depth
      );
      printf ("%02X", paletteEntry);
      */
    }
    printf ("\n");
  }

  printf ("\n");

  /* Grid 3: Alpha mask */
  for (y = 0; y < height; ++y) {
    for (x = 0; x < width; ++x) {
      printf ("%02X", 255);
    }
    printf ("\n");
  }

  fclose (ppmFile);
  goto end;

fail:
  ret = 1;

  if (ppmFile != NULL) {
    fclose (ppmFile);
    ppmFile = NULL;
  }

end:
  return ret;
}

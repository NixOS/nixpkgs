#include <stdbool.h>
#include <stddef.h>
#include <stdio.h>

#include <fpdf_edit.h>
#include <fpdfview.h>

int main(void) {
  int result = 1;
  FPDF_DOCUMENT document = NULL;
  FPDF_PAGE page = NULL;
  FPDF_BITMAP bitmap = NULL;

  FPDF_InitLibrary();

  document = FPDF_CreateNewDocument();
  if (!document) {
    fputs("failed to create document\n", stderr);
    goto cleanup;
  }

  page = FPDFPage_New(document, 0, 200, 100);
  if (!page) {
    fputs("failed to create page\n", stderr);
    goto cleanup;
  }

  FPDF_PAGEOBJECT rectangle = FPDFPageObj_CreateNewRect(10, 10, 50, 40);
  if (!rectangle || !FPDFPageObj_SetFillColor(rectangle, 255, 0, 0, 255) ||
      !FPDFPath_SetDrawMode(rectangle, FPDF_FILLMODE_WINDING, false)) {
    fputs("failed to create rectangle\n", stderr);
    FPDFPageObj_Destroy(rectangle);
    goto cleanup;
  }

  FPDFPage_InsertObject(page, rectangle);
  if (!FPDFPage_GenerateContent(page)) {
    fputs("failed to generate page content\n", stderr);
    goto cleanup;
  }

  bitmap = FPDFBitmap_Create(200, 100, false);
  if (!bitmap) {
    fputs("failed to create bitmap\n", stderr);
    goto cleanup;
  }

  FPDFBitmap_FillRect(bitmap, 0, 0, 200, 100, 0xffffffff);
  FPDF_RenderPageBitmap(bitmap, page, 0, 0, 200, 100, 0, 0);

  const unsigned char *buffer = FPDFBitmap_GetBuffer(bitmap);
  const size_t size = (size_t)FPDFBitmap_GetStride(bitmap) * 100;
  for (size_t i = 0; i < size; ++i) {
    if (buffer[i] != 0xff) {
      result = 0;
      break;
    }
  }

  if (result != 0) {
    fputs("rendering did not change the bitmap\n", stderr);
  }

cleanup:
  FPDFBitmap_Destroy(bitmap);
  FPDF_ClosePage(page);
  FPDF_CloseDocument(document);
  FPDF_DestroyLibrary();
  return result;
}

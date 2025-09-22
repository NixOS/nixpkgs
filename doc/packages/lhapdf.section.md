# LHAPDF {#lhapdf}

[LHAPDF](https://lhapdf.hepforge.org/) is a tool for evaluating parton distribution functions (PDFs) in high-energy physics. LHAPDF is available in the `lhapdf` package.

## PDF sets {#lhapdf-sets}

All of [the PDF sets made available by the LHAPDF project](https://lhapdf.hepforge.org/pdfsets.html) are available through the `lhapdf.pdf_sets` attrset.

### Setup hook {#lhapdf-sets-hook}

Each package provided in the `lhapdf.pdf_sets` attrset contains a setup hook which adds itself to [the `LHAPDF_DATA_PATH` environment variable](https://lhapdf.hepforge.org/#sets).

import ./generic.nix {
  version = "11.0.11";
  hash = "sha256-UZJW6C3Vn/e1KJEiyUI3o+/2xvKubjv+j1Lujmse//w=";
  npmDepsHash = "sha256-kh7/xZPr5Y8CzGs8hop0a9JNPzmB3w2FPpCb+xOCz0c=";
  vendorHash = "sha256-BL6wa+f+qFbDuHImMvAgwsqOTfV6Zt4oMBrOBI1sh1o=";
  lts = true;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/lts.nix"
  ];
}

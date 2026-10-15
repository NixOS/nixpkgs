import ./generic.nix {
  version = "17.0.0";
  hash = "sha256-uEl0a1+NOKpSal0fUyy8n1Ng8Vc+NUsEkWEXo9Az4W0=";
  npmDepsHash = "sha256-Zff93AC+zTACatAOdjtKt5luMmTOM5C3+2Y0BsVUf6A=";
  vendorHash = "sha256-vXjsZ08eez3oiLL2Um+uFX9YbrRnbq8q5Pj/P3mZTeY=";
  lts = false;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/package.nix"
  ];
}

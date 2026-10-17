{
  callPackage,
}:
let
  mkKops = callPackage ./mkkops.nix { };
in
{
  inherit mkKops;

  kops_1_32 = mkKops (finalAttrs: {
    version = "1.32.1";
    sha256 = "sha256-nQKeTDajtUffPBhPrPuaJ+1XWgLDUltwDQDZHkylys4=";
    rev = "v${finalAttrs.version}";
  });

  kops_1_33 = mkKops (finalAttrs: {
    version = "1.33.0";
    sha256 = "sha256-VnnKWcU83yqsKW54Q1tr99/Ln8ppMyB7GLl70rUFGDY=";
    rev = "v${finalAttrs.version}";
  });

  kops_1_34 = mkKops (finalAttrs: {
    version = "1.34.3";
    sha256 = "sha256-ERF/k12bfiZ2vK7kN3V+uhGcysRtxxL3YvrDefNkuTg=";
    rev = "v${finalAttrs.version}";
  });

  kops_1_35 = mkKops (finalAttrs: {
    version = "1.35.2";
    sha256 = "sha256-PQSjCmuaOZ3lEaThnjZDMSQVRG8bq2iMotnfo34OSFM=";
    rev = "v${finalAttrs.version}";
  });

  kops_1_36 = mkKops (finalAttrs: {
    version = "1.36.2";
    sha256 = "sha256-XKehbH0zk07xizLPETctPBrf2NqT+dwURJqKg5568kg=";
    rev = "v${finalAttrs.version}";
  });
}

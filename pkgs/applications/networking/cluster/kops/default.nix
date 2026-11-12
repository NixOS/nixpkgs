{
  callPackage,
}:
let
  mkKops = callPackage ./mkkops.nix { };
in
{
  inherit mkKops;

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

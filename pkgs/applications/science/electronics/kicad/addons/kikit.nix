# For building the multiple addons that are in the kikit repo.
{
  stdenv,
  bc,
  kikit,
  zip,
  python3,
  addonName,
  addonPath,
}:
let
  # This python is only used when building the package, it's not the python
  # environment that will ultimately run the code packaged here. The python env defined
  # in KiCad will import the python code packaged here when KiCad starts up.
  python = python3.withPackages (ps: with ps; [ click ]);
  kikit-module = python3.pkgs.toPythonModule (kikit.override { inherit python3; });

  # The following different addons can be built from the same source.
  targetSpecs = {
    "kikit" = {
      makeTarget = "pcm-kikit";
      resultZip = "pcm-kikit.zip";
      description = "KiCad plugin and a CLI tool to automate several tasks in a standard KiCad workflow";
    };
    "kikit-library" = {
      makeTarget = "pcm-lib";
      resultZip = "pcm-kikit-lib.zip";
      description = "KiKit uses these symbols and footprints to annotate your boards (e.g., to place a tab in a panel)";
    };
  };
  targetSpec = targetSpecs.${addonName};
in
stdenv.mkDerivation {
  name = "kicadaddon-${addonName}";
  inherit (kikit-module) src version;

  nativeBuildInputs = [
    python
    bc
    zip
  ];
  propagatedBuildInputs = [ kikit-module ];

  buildPhase = ''
    patchShebangs scripts/setJson.py
    make ${targetSpec.makeTarget}
  '';

  installPhase = ''
    mkdir $out
    mv build/${targetSpec.resultZip} $out/${addonPath}
  '';

  meta = kikit-module.meta // {
    description = targetSpec.description;
  };
}

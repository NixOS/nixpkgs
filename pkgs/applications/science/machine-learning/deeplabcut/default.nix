{ lib, writeText
, wrapGAppsHook
, gtk3
, opencv3
, python37
, mkl
 }:

let
  pythonOverrides = python-self: python-super: {
    # WARNING: openblas does not work
    # https://github.com/AlexEMG/DeepLabCut/issues/637#issuecomment-606893058

    # imgaug test stalls...
    imgaug = python-super.imgaug.overrideAttrs (old:{
      doInstallCheck = false;
    });

    opencv3 = python-super.toPythonModule (opencv3.override {
      enablePython = true;
      enableFfmpeg = true;
      pythonPackages = python-self;
    });
  };

  python = python37.override {
    packageOverrides = pythonOverrides;
  };
  py = python.pkgs;
in
py.toPythonApplication
  (py.deeplabcut.overridePythonAttrs(old: rec {
  pname = "deeplabcut-gui";

  script = writeText "deeplabcut"
    ''
      #!/usr/bin/env python
      import deeplabcut
      deeplabcut.launch_dlc()
    '';

  postInstall = ''
    ${old.postInstall}
    mkdir -p $out/bin
    cp ${script} $out/bin/deeplabcut
    chmod +x $out/bin/deeplabcut
  '';

  buildInputs = [
    gtk3
  ];

  nativeBuildInputs = old.nativeBuildInputs ++ [
    wrapGAppsHook
  ];
}))

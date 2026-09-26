{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

let
  version = "0.3.10";
in
python3Packages.buildPythonApplication {
  pname = "bili-live-tool";
  inherit version;

  src = fetchFromGitHub {
    owner = "chenxi-Eumenides";
    repo = "bilibili_live_tool";
    tag = "v${version}";
    hash = "sha256-0VqNGw3SUCPqJocHh5u6r0isj1Rg+guP2x/LsWqH4Ug=";
  };

  postPatch = ''
    tee >> pyproject.toml <<TOML
    [tool.setuptools]
    packages = ["src"]
    TOML
  '';

  pyproject = true;
  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    image
    pypinyin
    qrcode
    requests
  ];

  preInstall = ''
    mkdir -p $out/bin
    { echo '#!/bin/python'; cat main_cli.py; } > $out/bin/bili-live-tool
    chmod +x $out/bin/bili-live-tool
  '';

  nativeCheckInputs = with python3Packages; [ unittestCheckHook ];
  unittestFlags = [
    "-s"
    "unittest"
    "-v"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to start and stop streaming and getting streaming codes for Bilibili live";
    homepage = "https://github.com/chenxi-Eumenides/bilibili_live_tool";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ ulysseszhan ];
    mainProgram = "bili-live-tool";
  };
}

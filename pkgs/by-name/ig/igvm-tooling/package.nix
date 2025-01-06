{
  lib,
  python3,
  fetchFromGitHub,
  fetchpatch,
  which,
  acpica-tools,
  nix-update-script,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "igvm-tooling";
  version = "1.5.0-unstable-2024-06-06";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "igvm-tooling";
    rev = "53656ddde294bbafcae6349b5acfc5da9f7dbb92";
    hash = "sha256-X9Gi+kTmc/ZcsgbHldEj9zPnOmd5puDD7/+J1s1CVws=";
  };

  patches = [
    # drop unused libclang dependency
    # remove once https://github.com/microsoft/igvm-tooling/pull/53 is merged
    (fetchpatch {
      name = "0001-setup.py-remove-unused-libclang-dependency.patch";
      url = "https://github.com/microsoft/igvm-tooling/commit/7182e925de9b5e9f5c8c3a3ce6e3942a92506064.patch";
      hash = "sha256-tcVxcuLxknyEdo2YjeHOqSG9xQna8US+YyvlcfX+Htw=";
      stripLen = 1;
    })
  ];

  postPatch = ''
    substituteInPlace igvm/acpi.py \
      --replace-fail 'os.path.join(os.path.dirname(__file__), "acpi", "acpi.zip")' "\"$out/share/igvm-tooling/acpi/acpi.zip\""
  '';

  sourceRoot = "${src.name}/src";

  nativeBuildInputs = [ acpica-tools ];

  propagatedBuildInputs =
    (with python3.pkgs; [
      setuptools
      ecdsa
      cstruct
      pyelftools
      pytest
      cached-property
      frozendict
    ])
    ++ [
      acpica-tools
      which
    ];

  postInstall = ''
    mkdir -p $out/share/igvm-tooling/acpi/acpi-clh
    cp -rT igvm/acpi/acpi-clh $out/share/igvm-tooling/acpi/acpi-clh
    cp igvm/acpi/acpi.zip $out/share/igvm-tooling/acpi/acpi.zip
    find $out/share/igvm-tooling/acpi -name "*.dsl" -exec iasl -f {} \;
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "IGVM Image Generator";
    homepage = "https://github.com/microsoft/igvm-tooling";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      malt3
      katexochen
    ];
    changelog = "https://github.com/microsoft/igvm-tooling/releases/tag/igvm-${version}";
    mainProgram = "igvmgen";
    platforms = lib.platforms.all;
  };
}

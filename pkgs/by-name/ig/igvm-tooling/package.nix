{ lib
, python3
, fetchFromGitHub
, fetchpatch
, which
, acpica-tools
}:

python3.pkgs.buildPythonApplication rec {
  pname = "igvm-tooling";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "igvm-tooling";
    rev = "igvm-${version}";
    hash = "sha256-13TtiJv2w9WXSW6oPMfo+rRah+Q1wHV14aBaFGfz9CE=";
  };

  patches = [
    # drop unused libclang dependency
    # remove once https://github.com/microsoft/igvm-tooling/pull/53 is merged
    (fetchpatch {
      name = "0001-setup.py-remove-unused-libclang-dependency.patch";
      url = "https://github.com/microsoft/igvm-tooling/commit/7182e925de9b5e9f5c8c3a3ce6e3942a92506064.patch";
      sha256 = "sha256-tcVxcuLxknyEdo2YjeHOqSG9xQna8US+YyvlcfX+Htw=";
      stripLen = 1;
    })
    # write updated acpi files to tempdir (instead of nix store path) at runtime
    # remove once https://github.com/microsoft/igvm-tooling/pull/54 is merged
    (fetchpatch {
      name = "0002-acpi-update-dsl-files-in-tempdir.patch";
      url = "https://github.com/microsoft/igvm-tooling/commit/20f8d123ec6531d8540074b7df2ee12de60e73b8.patch";
      sha256 = "sha256-hNfkclxaYViy66TPHqLV3mqD7wqBuBN9MnMLaDOeRNM=";
      stripLen = 1;
    })
    # allow for determinist id block signing
    # remove once https://github.com/microsoft/igvm-tooling/pull/55 is merged
    (fetchpatch {
      name = "0003-add-deterministic-id-block-signature-mode.patch";
      url = "https://github.com/microsoft/igvm-tooling/commit/03ad7825ade76ac25e308bb85f92e89b732e0bf1.patch";
      sha256 = "sha256-Y7DFr0KgGtY8KOt6fLWd32sTaig/zHFe7n83+Yb9ls8=";
      stripLen = 1;
    })
  ];

  postPatch = ''
    substituteInPlace igvm/acpi.py \
      --replace-fail 'os.path.join(os.path.dirname(__file__), "acpi", "acpi.zip")' "\"$out/share/igvm-tooling/acpi/acpi.zip\""
  '';

  sourceRoot = "${src.name}/src";

  nativeBuildInputs = [ acpica-tools ];

  propagatedBuildInputs = with python3.pkgs; [
    setuptools
    ecdsa
    cstruct
    pyelftools
    pytest
    cached-property
    frozendict
  ] ++ [
    acpica-tools
    which
  ];

  postInstall = ''
    mkdir -p $out/share/igvm-tooling/acpi/acpi-clh
    cp -rT igvm/acpi/acpi-clh $out/share/igvm-tooling/acpi/acpi-clh
    cp igvm/acpi/acpi.zip $out/share/igvm-tooling/acpi/acpi.zip
    find $out/share/igvm-tooling/acpi -name "*.dsl" -exec iasl -f {} \;
  '';

  meta = {
    description = "IGVM Image Generator";
    homepage = "https://github.com/microsoft/igvm-tooling";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.malt3 ];
    changelog = "https://github.com/microsoft/igvm-tooling/releases/tag/igvm-${version}";
    mainProgram = "igvmgen";
    platforms = lib.platforms.all;
  };
}

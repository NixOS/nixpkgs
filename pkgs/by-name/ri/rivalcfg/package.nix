{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonPackage rec {
  pname = "rivalcfg";
  version = "4.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "flozz";
    repo = "rivalcfg";
    tag = "v${version}";
    sha256 = "sha256-UqVogJLv+sNhAxdMjBEvhBQw6LU+QUq1IekvWpeeMqk=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    hidapi
    setuptools # pkg_resources is imported during runtime
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  # tests are broken
  doCheck = false;

  postInstall = ''
    mkdir -p $out/lib/udev/rules.d
    tmpl_udev="$out/lib/udev/rules.d/99-rivalcfg.rules"
    tmpudev="''${tmpl_udev}.in"
    finaludev="$tmpl_udev"
    "$out/bin/rivalcfg" --print-udev > "$tmpudev"
    substitute "$tmpudev" "$out/lib/udev/rules.d/99-rivalcfg.rules" \
      --replace-fail MODE=\"0666\" "MODE=\"0664\", GROUP=\"input\""
    rm "$tmpudev"
  '';

  pythonImportsCheck = [ "rivalcfg" ];

  meta = with lib; {
    description = "Utility program that allows you to configure SteelSeries Rival gaming mice";
    homepage = "https://github.com/flozz/rivalcfg";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ ornxka ];
    mainProgram = "rivalcfg";
  };
}

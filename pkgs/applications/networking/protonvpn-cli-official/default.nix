{ lib
, python3Packages
, fetchFromGitHub
, dialog
}:

python3Packages.buildPythonApplication rec {
  pname = "protonvpn-linux-cli-official";
  version = "3.7.2";

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "linux-cli";
    rev = version;
    sha256 = "0n6qn1pqpx4q533h4yz4gz86kzs5hw7hisgazpj7fjirl66f0mlr";
  };

  propagatedBuildInputs = with python3Packages; [
    protonvpn-nm-lib
    pythondialog
  ] ++ [
    dialog
  ];

  strictDeps = false;
  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  # HOME is exported to mitigate issues with permissions
  preCheck = ''
    export HOME=$TMPDIR
  '';

  meta = with lib; {
    description = "ProtonVPN Linux CLI";
    homepage = "https://github.com/ProtonVPN/linux-cli";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ nkje ];
    platforms = platforms.linux;
  };
}

{
  fetchFromGitHub,
  freerdp,
  nmap,
  openvpn,
  python3Packages,
  lib,
  tigervnc,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "crowbar";
  version = "4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "galkan";
    repo = "crowbar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tLtQwrCh304I0AYCgSiFfMhJd0CdbAXSMymjd6SSC8A=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = [ python3Packages.paramiko ];

  patchPhase = ''
    sed -i 's,/usr/bin/xfreerdp,${freerdp}/bin/xfreerdp,g' lib/main.py
    sed -i 's,/usr/bin/vncviewer,${tigervnc}/bin/vncviewer,g' lib/main.py
    sed -i 's,/usr/sbin/openvpn,${openvpn}/bin/openvpn,g' lib/main.py

    sed -i 's,/usr/bin/nmap,${nmap}/bin/nmap,g' lib/nmap.py
  '';

  # Sanity check
  checkPhase = ''
    $out/bin/crowbar --help > /dev/null
  '';

  meta = {
    homepage = "https://github.com/galkan/crowbar";
    description = "Brute forcing tool that can be used during penetration tests";
    mainProgram = "crowbar";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pamplemousse ];
  };
})

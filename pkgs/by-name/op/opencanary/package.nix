{
  lib,
  apparmorRulesFromClosure,
  bash,
  coreutils,
  fetchPypi,
  glibc,
  iana-etc,
  locale,
  makeWrapper,
  nixosTests,
  python3,
  ...
}:

python3.pkgs.buildPythonApplication rec {
  pname = "opencanary";
  version = "0.9.2";
  format = "setuptools";

  disabled = python3.pkgs.pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oWwSIZanbUyqX8MmLMJit073kEzOpt/LommzFn1KInY=";
  };

  patches = [
    ./prepare-paths.patch
  ];

  nativeBuildInputs = [ makeWrapper ];

  propagatedBuildInputs = with python3.pkgs; [
    bcrypt
    cryptography
    fpdf
    hpfeeds
    jinja2
    ntlmlib
    passlib
    pcapy-ng
    pyasn1
    pyopenssl
    pypdf2
    requests
    scapy
    service-identity
    setuptools
    simplejson
    twisted
    zope_interface
  ];

  postPatch = ''
    # Fix shebang and invalid bin dirs
    substituteInPlace bin/opencanaryd \
      --replace "@@BASH@@" "#!${lib.getExe bash}" \
      --replace "@@OUTBIN@@" "$out/bin"
  '';

  postInstall = ''
    # Fixes missing 'pkg_resources' and 'opencanary' modules
    wrapProgram $out/bin/opencanaryd \
      --prefix PATH : ${python3}/bin \
      --suffix PATH : ${lib.makeBinPath propagatedBuildInputs} \
      --set NIX_PYTHONPATH "$PYTHONPATH:$out/${python3.sitePackages}"

    # Install apparmor profile
    mkdir $apparmor
    cat <<EOF > $apparmor/bin.opencanaryd
    include <tunables/global>
    $out/bin/opencanaryd {
      include <abstractions/base>
      include <abstractions/bash>
      include <abstractions/consoles>
      include <abstractions/python>
      include "${apparmorRulesFromClosure { name = "opencanaryd"; } ([
          coreutils glibc iana-etc locale python3
      ] ++ propagatedBuildInputs)}"

      r    @{PROC}/@{pid}/cgroup,
      r    @{PROC}/@{pid}/net/dev,
      r    @{PROC}/@{pid}/net/if_inet6,
      r    @{PROC}/@{pid}/net/ipv6_route,
      r    @{PROC}/@{pid}/net/route,
      ix   ${lib.getExe bash},
      rix  ${python3.pkgs.twisted}/bin/**,
      rmix $out/**,
      rw   /etc/opencanaryd/**,
      rw   /var/lib/opencanaryd/**,
      rw   /var/log/opencanaryd/**,
      owner rw /var/tmp/*,
      capability net_admin net_bind_service net_raw,
      network tcp,
    }
    EOF
  '';

  checkPhase = ''
    runHook preCheck
    ${python3.interpreter} -m unittest
    runHook postCheck
  '';

  passthru.tests = {
    opencanary = nixosTests.opencanary;
  };

  meta = {
    description = "A low interaction honeypot intended to be run on internal networks.";
    homepage = "https://github.com/thinkst/opencanary";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ purefns ];
    mainProgram = "opencanaryd";
  };
}

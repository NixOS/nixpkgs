{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  unbound,
  libreswan,
}:

stdenv.mkDerivation rec {
  pname = "hash-slinger";
  version = "3.4";

  src = fetchFromGitHub {
    owner = "letoams";
    repo = "hash-slinger";
    rev = version;
    sha256 = "sha256-IN+jo2EuGx+3bnANKz+d/3opFBUCSmkBS/sCU3lT7Zs=";
  };

  pythonPath = with python3.pkgs; [
    dnspython
    m2crypto
    python-gnupg
    pyunbound
  ];

  buildInputs = [
    python3.pkgs.wrapPython
  ];

  propagatedBuildInputs = [
    unbound
    libreswan
  ]
  ++ pythonPath;

  propagatedUserEnvPkgs = [
    unbound
    libreswan
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace "$(DESTDIR)/usr" "$out"
    substituteInPlace ipseckey \
      --replace "/usr/sbin/ipsec" "${libreswan}/sbin/ipsec"
    substituteInPlace tlsa \
      --replace "/var/lib/unbound/root" "${python3.pkgs.pyunbound}/etc/pyunbound/root"
    patchShebangs *
  '';

  installPhase = ''
    mkdir -p $out/bin $out/man $out/${python3.sitePackages}
    make install
    wrapPythonPrograms
  '';

  meta = with lib; {
    description = "Various tools to generate special DNS records";
    homepage = "https://github.com/letoams/hash-slinger";
    license = licenses.gpl2Plus;
  };
}

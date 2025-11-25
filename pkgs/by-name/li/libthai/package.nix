{
  lib,
  stdenv,
  fetchurl,
  installShellFiles,
  pkg-config,
  libdatrie,
}:

stdenv.mkDerivation rec {
  pname = "libthai";
  version = "0.1.29";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "https://github.com/tlwg/libthai/releases/download/v${version}/libthai-${version}.tar.xz";
    sha256 = "sha256-/IDMfctQ4RMCtBfOvSTy0wqLmHKS534AMme5EA0PS80=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    installShellFiles
    (lib.getBin libdatrie)
    pkg-config
  ];

  buildInputs = [ libdatrie ];

  postInstall = ''
    installManPage man/man3/*.3
  '';

  meta = {
    homepage = "https://linux.thai.net/projects/libthai/";
    description = "Set of Thai language support routines";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ crertel ];
    pkgConfigModules = [ "libthai" ];
  };
}

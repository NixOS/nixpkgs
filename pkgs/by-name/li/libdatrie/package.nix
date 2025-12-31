{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  autoconf-archive,
  installShellFiles,
  libiconv,
}:

stdenv.mkDerivation rec {

  pname = "libdatrie";
  version = "2019-12-20";

  outputs = [
    "bin"
    "out"
    "lib"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "tlwg";
    repo = "libdatrie";
    rev = "d1db08ac1c76f54ba23d63665437473788c999f3";
    sha256 = "03dc363259iyiidrgadzc7i03mmfdj8h78j82vk6z53w6fxq5zxc";
  };

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    installShellFiles
  ];

  buildInputs = [ libiconv ];

  preAutoreconf =
    let
      reports = "https://github.com/tlwg/libdatrie/issues";
    in
    ''
      sed -i -e "/AC_INIT/,+3d" configure.ac
      sed -i "5iAC_INIT(${pname},${version},[${reports}])" configure.ac
    '';

  postInstall =
    lib.optionalString stdenv.hostPlatform.isMinGW ''
      # Upstream's install hook creates `trietool-0.2 -> trietool`, but on MinGW
      # the executable is `trietool.exe`, leaving a dangling symlink that fails
      # Nix's noBrokenSymlinks fixup.
      #
      # Mirror MSYS2 behavior: provide a versioned `.exe` and ensure the
      # unversioned name exists as a shim.
      if [ -L "$bin/bin/trietool-0.2" ]; then
        rm -f "$bin/bin/trietool-0.2"
      fi

      if [ -e "$bin/bin/trietool.exe" ]; then
        cp -f "$bin/bin/trietool.exe" "$bin/bin/trietool-0.2.exe"

        if [ ! -e "$bin/bin/trietool" ]; then
          ln -s trietool.exe "$bin/bin/trietool"
        fi

        ln -s trietool-0.2.exe "$bin/bin/trietool-0.2"
      fi
    ''
    + ''
      installManPage man/trietool.1
    '';

  meta = {
    homepage = "https://linux.thai.net/~thep/datrie/datrie.html";
    description = "This is an implementation of double-array structure for representing trie";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    maintainers = [ ];
    pkgConfigModules = [ "datrie-0.2" ];
  };
}

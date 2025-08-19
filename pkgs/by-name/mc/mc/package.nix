{
  lib,
  stdenv,
  fetchurl,
  buildPackages,
  pkg-config,
  glib,
  gpm,
  file,
  e2fsprogs,
  libICE,
  perl,
  zip,
  unzip,
  gettext,
  slang,
  libssh2,
  openssl,
  coreutils,
  darwin,
  x11Support ? true,
  libX11,

  # updater only
  writeScript,
}:

stdenv.mkDerivation rec {
  pname = "mc";
  version = "4.8.33";

  src = fetchurl {
    url = "https://ftp.osuosl.org/pub/midnightcommander/${pname}-${version}.tar.xz";
    hash = "sha256-yuFJ1C+ETlGF2MgdfbOROo+iFMZfhSIAqdiWtGivFkw=";
  };

  nativeBuildInputs = [
    pkg-config
    unzip
  ]
  # The preFixup hook rewrites the binary, which invaliates the code
  # signature. Add the fixup hook to sign the output.
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    darwin.autoSignDarwinBinariesHook
  ];

  buildInputs = [
    file
    gettext
    glib
    libICE
    libssh2
    openssl
    slang
    zip
  ]
  ++ lib.optionals x11Support [ libX11 ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    e2fsprogs
    gpm
  ];

  enableParallelBuilding = true;

  configureFlags = [
    # used for vfs helpers at run time:
    "PERL=${perl}/bin/perl"
    # used for .hlp generation at build time:
    "PERL_FOR_BUILD=${buildPackages.perl}/bin/perl"

    # configure arguments have a bunch of build-only dependencies.
    # Avoid their retention in final closure.
    "--disable-configure-args"
  ];

  postPatch = ''
    substituteInPlace src/filemanager/ext.c \
      --replace /bin/rm ${coreutils}/bin/rm
  '';

  postFixup = lib.optionalString ((!stdenv.hostPlatform.isDarwin) && x11Support) ''
    # libX11.so is loaded dynamically so autopatch doesn't detect it
    patchelf \
      --add-needed ${libX11}/lib/libX11.so \
      $out/bin/mc
  '';

  passthru.updateScript = writeScript "update-mc" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl pcre common-updater-scripts

    set -eu -o pipefail

    # Expect the text in format of "Current version is: 4.8.27; ...".
    new_version="$(curl -s https://midnight-commander.org/ | pcregrep -o1 'Current version is: (([0-9]+\.?)+);')"
    update-source-version mc "$new_version"
  '';

  meta = with lib; {
    description = "File Manager and User Shell for the GNU Project, known as Midnight Commander";
    downloadPage = "https://ftp.osuosl.org/pub/midnightcommander/";
    homepage = "https://midnight-commander.org";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ sander ];
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "mc";
  };
}

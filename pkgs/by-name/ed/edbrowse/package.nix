{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  perl,
  curl,
  openssl,
  pcre2,
  quickjs-ng,
  readline,
  unixODBC,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "edbrowse";
  version = "3.8.15";

  src = fetchFromGitHub {
    owner = "edbrowse";
    repo = "edbrowse";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KVNmcS9eWIS0GZgXcxMirjNtl0b1pwJWSzv/edsU7Tk=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  nativeBuildInputs = [
    pkg-config
    perl
  ];

  buildInputs = [
    curl
    openssl
    pcre2
    quickjs-ng
    readline
    unixODBC
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "QUICKJS_INCLUDE=${lib.getDev quickjs-ng}/include"
    "QUICKJS_LIB=${lib.getLib quickjs-ng}/lib"
    "QUICKJS_LIB_NAME=qjs"
    "EBDEMIN=on"
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  enableParallelBuilding = true;

  postInstall = ''
    install -Dm644 ../doc/man-edbrowse-debian.1 $out/share/man/man1/edbrowse.1
    substituteInPlace $out/share/man/man1/edbrowse.1 \
      --replace-fail "/usr/share/doc/edbrowse" "$out/share/doc/edbrowse"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://edbrowse.org/";
    description = "Command line editor, browser, and mail client";
    longDescription = ''
      Edbrowse is a combination editor, browser, and mail client that is 100%
      text based. The interface is similar to /bin/ed, though there are many
      more features, such as editing multiple files simultaneously, and
      rendering html. This program was originally written for blind users, but
      many sighted users have taken advantage of the unique scripting
      capabilities of this program, which can be found nowhere else. A batch
      job, or cron job, can access web pages on the internet, submit forms, and
      send email, with no human intervention whatsoever. edbrowse can also tap
      into databases through ODBC.
    '';
    license = lib.licenses.gpl1Plus;
    mainProgram = "edbrowse";
    maintainers = with lib.maintainers; [ jhhuh ];
    platforms = lib.platforms.linux;
  };
})

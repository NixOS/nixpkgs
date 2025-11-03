{
  lib,
  stdenv,
  fetchurl,
  directoryListingUpdater,
  gawk,
  man,
  pcre2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "man-pages";
  version = "6.16";

  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/man-pages-${finalAttrs.version}.tar.xz";
    hash = "sha256-jiR6vXXNgICc/ghpbIG4xwaQWDsEV0lISyQvtDYx16M=";
  };

  nativeInstallCheckInputs = [
    gawk
    man
    pcre2
  ];

  dontBuild = true;
  enableParallelInstalling = true;
  doInstallCheck = true;

  makeFlags = [
    "-R"
    "VERSION=${finalAttrs.version}"
    "prefix=${placeholder "out"}"
  ];

  preConfigure = ''
    # If not provided externally, the makefile will attempt to determine the
    # date and time of the release from the Git repository log, which is not
    # available in the distributed tarball. We therefore supply it from
    # $SOURCE_DATE_EPOCH, which is based on the most recent modification time
    # of all source files. Cf.
    # nixpkgs/pkgs/build-support/setup-hooks/set-source-date-epoch-to-latest.sh
    export DISTDATE="$(date --utc --date="@$SOURCE_DATE_EPOCH")"
  '';

  installCheckPhase = ''
    runHook preInstallCheck

    # Check for a few well‐known man pages
    for page in ldd write printf null hosts random ld.so; do
      man -M "$out/share/man" -P cat "$page" >/dev/null
    done

    runHook postInstallCheck
  '';

  passthru.updateScript = directoryListingUpdater {
    url = "https://www.kernel.org/pub/linux/docs/man-pages/";
  };

  meta = {
    description = "Linux development manual pages";
    homepage = "https://www.kernel.org/doc/man-pages/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    priority = 30; # if a package comes with its own man page, prefer it
  };
})

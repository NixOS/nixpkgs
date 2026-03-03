{
  lib,
  stdenv,
  fetchurl,
  directoryListingUpdater,
  gawk,
  man,
  pcre2,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "man-pages";
  version = "6.17";

  # `man` is first: most people installing `man-pages` want man pages.
  # The binaries could be split to a seperate package (as upstream suggests),
  # but storing in a seperate not-installed-by-default output is easier,
  # and has a similar effect.
  outputs = [
    "man"
    "out"
  ];

  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/man-pages-${finalAttrs.version}.tar.xz";
    hash = "sha256-0Y8hpgKwl3ilqQlr8b6EQbdzPpmBUEdKzPcD0WX06/Q=";
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
    "bindir=${placeholder "out"}/bin"
    "mandir=${placeholder "man"}/share/man"
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

    # Check for a few well-known man pages
    for page in ldd write printf null hosts random ld.so; do
      man -M "$man/share/man" -P cat "$page" >/dev/null
    done

    runHook postInstallCheck
  '';

  passthru = {
    tests = { inherit (nixosTests) man; };
    updateScript = directoryListingUpdater {
      url = "https://www.kernel.org/pub/linux/docs/man-pages/";
    };
  };

  meta = {
    description = "Linux development manual pages";
    longDescription = ''
      This package provides the manual pages in its "man" output,
      and various utility programs in its "out" output.

      Only the "man" output is installed by default.
    '';
    homepage = "https://www.kernel.org/doc/man-pages/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ mdaniels5757 ];
    platforms = lib.platforms.unix;
    outputsToInstall = [ "man" ];
    priority = 30; # if a package comes with its own man page, prefer it
  };
})

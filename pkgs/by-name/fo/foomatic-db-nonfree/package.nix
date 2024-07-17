{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "foomatic-db-nonfree";
  version = "unstable-2015-06-05";

  src = fetchFromGitHub {
    # there is also a daily snapshot at the `downloadPage`,
    # but it gets deleted quickly and would provoke 404 errors
    owner = "OpenPrinting";
    repo = "foomatic-db-nonfree";
    rev = "6ddae02ac89240c019f8b5026cfe70e30fd2b3db";
    hash = "sha256-cRZH0CXg03FEqUJdxaNnPVXjf8+ct86PjhL59WQbw60=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    perl
  ];

  # sed-substitute indirection is more robust against
  # characters in paths that might need escaping
  postPatch = ''
    sed -Ei -e 's|^(S?BINSEARCHPATH=).+$|\1"@PATH@"|g'  \
      -e 's|^(DATASEARCHPATH=).+$|\1"@DATA@"|g' configure.ac
    substituteInPlace configure.ac  \
      --subst-var PATH  \
      --subst-var-by DATA "${placeholder "out"}/share"
  '';

  preConfigure = ''
    mkdir -p "${placeholder "out"}/share/foomatic/db/source"
    ./make_configure
  '';

  # make ppd files available to cups,
  # use a package-specific subdirectory to avoid
  # conflicts with other ppd-containing packages
  postInstall = ''
    if ! [[ -d "${placeholder "out"}/share/foomatic/db/source/PPD" ]]; then
        echo "failed to create share/foomatic/db/source/PPD"
        exit 1
    fi
    mkdir -p "${placeholder "out"}/share/cups/model"
    ln -s "${placeholder "out"}/share/foomatic/db/source/PPD"  \
      "${placeholder "out"}/share/cups/model/foomatic-db-nonfree"
  '';

  # we might patch ppd file commands with `patchPpdFilesHook`,
  # but the only command "rastertophaser6100" isn't packaged yet

  # compress ppd files
  postFixup = ''
    echo 'compressing ppd files'
    find -H "${placeholder "out"}/share/cups/model/foomatic-db-nonfree" -type f -iname '*.ppd' -print0  \
      | xargs -0r -n 64 -P "$NIX_BUILD_CORES" gzip -9n
  '';

  meta = {
    changelog = "https://github.com/OpenPrinting/foomatic-db-nonfree/blob/${finalAttrs.src.rev}/ChangeLog";
    description = "OpenPrinting printer support database (unfree content)";
    downloadPage = "https://www.openprinting.org/download/foomatic/";
    homepage = "https://openprinting.github.io/projects/02-foomatic/";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.yarny ];
    # list printer manufacturers here so people
    # searching for ppd files can find this package
    longDescription = ''
      The collected knowledge about printers,
      drivers, and driver options in XML files,
      used by `foomatic-db-engine` to generate PPD files.
      This is a package of PPD and Foomatic XML files
      that may have restrictions that keep them
      from being used on a variety of machines
      for licensing and other non-technical reasons.
      The XML files in this package enable `foomatic-db-ppds`
      to create about 120 additional PPD files, for printer from
      Dell, Genicom, Lexmark, Oce, Tektronix and Xerox.
      Besides the XML files, this package contains
      about 130 PPD files, for printers from
      Dell, Genicom, Lexmark, Oce and Xerox.
    '';
  };
})

{
  fetchgit,
  fetchpatch,
  gnucap,
  installShellFiles,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnucap-modelgen-verilog";
  version = "20260729-dev";

  src = fetchgit {
    url = "https://https.git.savannah.gnu.org/git/gnucap/gnucap-modelgen-verilog.git";
    tag = finalAttrs.version;
    hash = "sha256-GfMfwSZOpi/NKWLporb8pVEeNthxWV7gIxbeiebo3Fk=";
  };
  patches = [
    # Make build work with `-Werror=format-security`
    (fetchpatch {
      name = "gnucap-modelgen-verilog-fprintf.patch";
      url = "https://codeberg.org/gnucap/gnucap-modelgen-verilog/commit/172fc7cddb66b79febab3b87fc1b9e87bee80308.patch";
      hash = "sha256-oURJ96qr7RnT6Pn5+GRO1k9K/8CLXfOfdoZgWYO8a58=";
    })
  ];

  nativeBuildInputs = [
    installShellFiles
  ];
  propagatedBuildInputs = [ gnucap ];

  doCheck = true;

  preInstall = ''
    export GNUCAP_EXEC_PREFIX=$out
    export GNUCAP_DATA=$out/share/gnucap
    mkdir -p $out/include/gnucap
    export GNUCAP_INCLUDEDIR=$out/include/gnucap
    export GNUCAP_PKGLIBDIR=$out/lib/gnucap
  '';

  postInstall = ''
    installManPage man/*.*
  '';

  meta = {
    description = "gnucap modelgen to preprocess, parse and dump vams files";
    homepage = "http://www.gnucap.org/";
    mainProgram = "gnucap-mg-vams";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.raboof ];
  };
})

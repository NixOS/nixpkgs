{
  fetchgit,
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
    ./modelgen-verilog-format.patch
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

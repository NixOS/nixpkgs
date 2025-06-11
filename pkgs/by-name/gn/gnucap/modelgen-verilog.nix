{
  fetchFromSavannah,
  gnucap,
  installShellFiles,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnucap-modelgen-verilog";
  version = "20240220";

  src = fetchFromSavannah {
    repo = "gnucap/gnucap-modelgen-verilog";
    rev = finalAttrs.version;
    hash = "sha256-hDH+aUuCjr5JK2UOy1diNXJaqt6Lrw4GgiiZmQ/SaQs=";
  };

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

  meta = with lib; {
    description = "gnucap modelgen to preprocess, parse and dump vams files";
    homepage = "http://www.gnucap.org/";
    changelog = "https://git.savannah.gnu.org/cgit/gnucap.git/plain/NEWS?h=v${version}";
    mainProgram = "gnucap-mg-vams";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.raboof ];
  };
})

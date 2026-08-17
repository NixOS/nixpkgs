{
  lib,
  fetchFromSourcehut,
  python312Packages,
}:

python312Packages.buildPythonApplication (finalAttrs: {
  pname = "brutalmaze";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromSourcehut {
    owner = "~cnx";
    repo = "brutalmaze";
    tag = finalAttrs.version;
    sha256 = "1m105iq378mypj64syw59aldbm6bj4ma4ynhc50gafl656fabg4y";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "pygame" "pygame-ce"
  '';

  nativeBuildInputs = with python312Packages; [
    flit-core
  ];

  propagatedBuildInputs = with python312Packages; [
    loca
    palace
    pygame-ce
  ];

  doCheck = false; # there's no test

  meta = {
    description = "Minimalist thrilling shoot 'em up game";
    mainProgram = "brutalmaze";
    homepage = "https://brutalmaze.rtfd.io";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.McSinyx ];
  };
})

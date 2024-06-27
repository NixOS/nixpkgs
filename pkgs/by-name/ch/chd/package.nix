{
  fetchFromSourcehut,
  stdenv,
  lib,
  installShellFiles,
}:

stdenv.mkDerivation {
  pname = "chd";
  version = "0-unstable-2022-02-01";

  src = fetchFromSourcehut {
    owner = "~breadbox";
    repo = "chd";
    rev = "94c77dbb53fe816be890d9a830cca7fe79076988";
    hash = "sha256-RxOMAF0JYMmpxIqpiIW7DLia7iUNJ7V8C2vji81N9U8=";
  };

  nativeBuildInputs = [ installShellFiles ];

  postPatch = ''
    # allow overriding compiler and flags
    substituteInPlace Makefile \
      --replace-fail '=' '?='
  '';

  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    install -Dm555 chd -t $out/bin
    installManPage chd.1

    runHook postInstall
  '';

  meta = {
    description = "Unicode-aware replacement for xxd/hexdump";
    homepage = "https://www.muppetlabs.com/~breadbox/software/chd.html";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eclairevoyant ];
    mainProgram = "chd";
    platforms = lib.platforms.linux;
  };
}

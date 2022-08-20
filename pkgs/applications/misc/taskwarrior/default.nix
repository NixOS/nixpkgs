{ lib, stdenv, fetchFromGitHub, cmake, libuuid, gnutls, python3, xdg-utils }:

stdenv.mkDerivation rec {
  pname = "taskwarrior";
  version = "2.6.2";

  src = fetchFromGitHub {
    owner = "GothenburgBitFactory";
    repo = "taskwarrior";
    rev = "v${version}";
    sha256 = "sha256-0YveqiylXJi4cdDCfnPtwCVOJbQrZYsxnXES+9B4Yfw=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace src/commands/CmdNews.cpp \
      --replace "xdg-open" "${lib.getBin xdg-utils}/bin/xdg-open"
  '';

  nativeBuildInputs = [ cmake libuuid gnutls python3 ];

  doCheck = true;
  preCheck = ''
    patchShebangs --build test
  '';
  checkTarget = "test";

  postInstall = ''
    mkdir -p "$out/share/bash-completion/completions"
    ln -s "../../doc/task/scripts/bash/task.sh" "$out/share/bash-completion/completions/task.bash"
    mkdir -p "$out/share/fish/vendor_completions.d"
    ln -s "../../../share/doc/task/scripts/fish/task.fish" "$out/share/fish/vendor_completions.d/"
  '';

  meta = with lib; {
    description = "Highly flexible command-line tool to manage TODO lists";
    homepage = "https://taskwarrior.org";
    license = licenses.mit;
    maintainers = with maintainers; [ marcweber oxalica ];
    mainProgram = "task";
    platforms = platforms.unix;
  };
}

{lib, fetchFromSourcehut, buildGoModule}:

buildGoModule rec {
  pname = "gembro";
  version = "unstable-2022-01-25";

  src = fetchFromSourcehut {
    owner = "~rafael";
    repo = pname;
    rev = "af806922084db15a040dc59a8f3666e60ac4b1f0";
    hash = "sha256-7uimpoNJjk3htMHmCPRVpy11mu2wjQk4DVSTzRQ2h5o=";
  };

  vendorHash = "sha256-EiDG2iWtkMTokQBsmd2vfUSHz6Jf98V2Yj3nU76sKPc=";

  meta = with lib; {
    description = "A mouse-driven CLI Gemini client with Gopher support";
    mainProgram = "gembro";
    homepage = "https://git.sr.ht/~rafael/gembro";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ imadnyc ];
  };
}


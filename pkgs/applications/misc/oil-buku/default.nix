{ stdenvNoCC, lib, fetchFromGitHub, jq, gawk, peco, makeWrapper }:

stdenvNoCC.mkDerivation rec {
  pname = "oil-buku";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "AndreiUlmeyda";
    repo = "oil";
    rev = version;
    sha256 = "12g0fd7h11hh94b2pyg3pqwbf8bc7gcnrnm1qqbf18s6z02b6ixr";
  };

  postPatch = ''
    substituteInPlace src/oil --replace \
      "LIBDIR=/usr/local/lib/oil" "LIBDIR=${placeholder "out"}/lib"

    substituteInPlace src/json-to-line.jq --replace \
      "/usr/bin/env -S jq" "${jq}/bin/jq"

    substituteInPlace src/format-columns.awk --replace \
      "/usr/bin/env -S awk" "${gawk}/bin/awk"
  '';

  makeFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "LIBDIR=${placeholder "out"}/lib"
  ];

  nativeBuildInputs = [ makeWrapper ];

  postFixup = ''
    wrapProgram $out/bin/oil \
        --prefix PATH : ${lib.makeBinPath [ peco ]}
  '';

  meta = with lib; {
    description = "Search-as-you-type cli frontend for the buku bookmarks manager using peco";
    homepage = "https://github.com/AndreiUlmeyda/oil";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ atila ];
    mainProgram = "oil";
    platforms = platforms.unix;
  };
}

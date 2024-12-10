{
  lib,
  mupdf,
  stdenv,
  fetchFromGitHub,
  substituteAll,
  cmake,
  qt6,
  desktopToDarwinBundle,
}:

let
  mupdf-cxx = mupdf.override { enableCxx = true; };
in
stdenv.mkDerivation rec {
  pname = "librum";
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = "Librum-Reader";
    repo = "Librum";
    rev = "v.${version}";
    fetchSubmodules = true;
    hash = "sha256-Iwcbcz8LrznFP8rfW6mg9p7klAtTx4daFxylTeFKrH0=";
  };

  patches = [
    (substituteAll {
      src = ./use_mupdf_in_nixpkgs.patch;
      nixMupdfLibPath = "${mupdf-cxx.out}/lib";
      nixMupdfIncludePath = "${mupdf-cxx.dev}/include";
    })
  ];

  nativeBuildInputs =
    [
      cmake
      qt6.qttools
      qt6.wrapQtAppsHook
    ]
    ++ lib.optionals stdenv.isDarwin [
      desktopToDarwinBundle
    ];

  buildInputs =
    [
      qt6.qtbase
      qt6.qtsvg
    ]
    ++ lib.optionals stdenv.isLinux [
      qt6.qtwayland
    ];

  meta = with lib; {
    description = "An application designed to make reading enjoyable and straightforward";
    longDescription = ''
      Librum is an application designed to make reading enjoyable
      and straightforward for everyone. It's not just an e-book
      reader. With Librum, you can manage your own online library
      and access it from any device anytime, anywhere. It has
      features like note-taking, AI tooling, and highlighting,
      while offering customization to make it as personal as you
      want! Librum also provides free access to over 70,000 books
      and personal reading statistics while being free and
      completely open source.
    '';
    homepage = "https://librumreader.com";
    license = licenses.gpl3Plus;
    mainProgram = "librum";
    maintainers = with maintainers; [
      aleksana
      oluceps
    ];
    platforms = platforms.unix;
  };
}

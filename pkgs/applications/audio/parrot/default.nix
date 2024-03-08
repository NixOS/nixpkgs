{ lib
, rustPlatform
, fetchFromGitHub
, cmake
, ffmpeg
, libopus
, makeBinaryWrapper
, nix-update-script
, openssl
, pkg-config
, stdenv
, yt-dlp
, Security
}:
let
  version = "1.6.0";
in
rustPlatform.buildRustPackage {
  pname = "parrot";
  inherit version;

  src = fetchFromGitHub {
    owner = "aquelemiguel";
    repo = "parrot";
    rev = "v${version}";
    hash = "sha256-f6YAdsq2ecsOCvk+A8wsUu+ywQnW//gCAkVLF0HTn8c=";
  };

  cargoHash = "sha256-e4NHgwoNkZ0//rugHrP0gU3pntaMeBJsV/YSzJfD8r4=";

  nativeBuildInputs = [ cmake makeBinaryWrapper pkg-config ];

  buildInputs = [ libopus openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security ];

  postInstall = ''
    wrapProgram $out/bin/parrot \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg yt-dlp ]}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A hassle-free Discord music bot";
    homepage = "https://github.com/aquelemiguel/parrot";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gerg-l ];
    mainProgram = "parrot";
  };
}

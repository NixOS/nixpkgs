{
  lib,
  fetchFromGitHub,
  buildGoModule,
  buildNpmPackage,
  inter,
  ffmpeg,
}:
let
  version = "3.3.1";
  src = fetchFromGitHub {
    owner = "5rahim";
    repo = "seanime";
    rev = "v${version}";
    hash = "sha256-kK5f/71/LuBVNJLiMfPJsJjxvf6ZorGxtVwC9rX2MEk=";
  };

  seanime-web = buildNpmPackage {
    pname = "seanime-web";

    inherit src version;

    sourceRoot = "${src.name}/seanime-web";

    patches = [ ./default-disable-update-check.patch ];

    npmDepsHash = "sha256-rRgp8nXuRvCSOLo040i4ZL+0GCYkEEnkxpgwqDBt/EY=";

    # nextjs seems to require relative paths
    postPatch = ''
      cp "${inter}/share/fonts/truetype/InterVariable.ttf" src/app/Inter.ttf

      substituteInPlace ./src/app/layout.tsx \
        --replace-fail 'import { Inter } from "next/font/google"' 'import localFont from "next/font/local"' \
        --replace-fail 'const inter = Inter({ subsets: ["latin"] })' 'const inter = localFont({ src: "./Inter.ttf" })'

      substituteInPlace './src/app/(main)/entry/_containers/torrent-stream/torrent-stream-overlay.tsx' \
        --replace-fail 'import { Inter } from "next/font/google"' 'import localFont from "next/font/local"' \
        --replace-fail 'const inter = Inter({ subsets: ["latin"] })' 'const inter = localFont({ src: "../../../../Inter.ttf" })'
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r out $out/web

      runHook postInstall
    '';
  };
in
buildGoModule {
  pname = "seanime";

  inherit src version;

  vendorHash = "sha256-6KM3fGpK78wRnP+PKSY/NKexzz/3WxBDRkhnQzoE5KY=";

  preBuild = ''
    cp -r ${seanime-web}/web .

    # .github scripts redeclare main
    rm -rf .github
  '';

  subPackages = [ "." ];

  doCheck = false; # broken in clean environments

  ldflags = [
    "-s"
    "-w"
  ];

  makeWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        ffmpeg
      ]
    }"
  ];

  meta = {
    description = "Open-source media server for anime and manga";
    homepage = "https://seanime.app";
    changelog = "https://github.com/5rahim/seanime/blob/main/CHANGELOG.md";
    mainProgram = "seanime";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ thegu5 ];
  };
}

{
  lib,
  fetchFromGitHub,
  esbuild,
  buildNpmPackage,
  inter,
}:

buildNpmPackage rec {
  pname = "pangolin";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "fosrl";
    repo = "pangolin";
    tag = version;
    hash = "sha256-2yrim4pr8cgIh/FBuGIuK+ycwImpMiz+m21H5qYARmU=";
  };

  npmDepsHash = "sha256-fi4e79Bk1LC/LizBJ+EhCjDzLR5ZocgVyWbSXsEJKdw=";
  nativeBuildInputs = [ esbuild ];
  # Replace the googleapis.com Inter font with a local copy from nixpkgs
  # based on
  # https://github.com/NixOS/nixpkgs/blob/f7bf574774e466b984063a44330384cdbca67d6c/pkgs/by-name/ne/nextjs-ollama-llm-ui/package.nix
  postPatch = ''
    substituteInPlace src/app/layout.tsx --replace-fail \
      "{ Figtree, Inter } from \"next/font/google\"" \
      "localFont from \"next/font/local\""

    substituteInPlace src/app/layout.tsx --replace-fail \
      "Inter({ subsets: [\"latin\"] })" \
      "localFont({ src: './Inter.ttf' })"

    cp "${inter}/share/fonts/truetype/InterVariable.ttf" src/app/Inter.ttf
  '';

  preBuild = ''
    npx drizzle-kit generate --dialect sqlite --schema ./server/db/schemas/ --out init
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/

    cp -r .next/standalone/* $out/
    cp -r .next/standalone/.next $out/

    cp -r .next/static $out/.next/static
    cp -r dist $out/dist
    cp -r init $out/dist/init

    cp server/db/names.json $out/dist/names.json
    cp -r public $out/public
    cp -r node_modules $out/
    runHook postInstall
  '';

  meta = {
    description = "Tunneled reverse proxy server with identity and access control";
    homepage = "https://github.com/fosrl/pangolin";
    changelog = "https://github.com/fosrl/pangolin/releases/tag/${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ jackr ];
    platforms = lib.platforms.linux;
  };
}

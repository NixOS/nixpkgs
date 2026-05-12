/**
  ## Attributions

  - https://nixos.wiki/wiki/Packaging/Ruby
  - https://github.com/NixOS/nixpkgs/blob/711f1d946e67ccf0e2191d85a1c0d0dcfb5df704/doc/languages-frameworks/ruby.section.md
*/
{
  fetchFromGitHub,
  fetchYarnDeps,
  lib,
  nodejs,
  rubyPackages_4_0,
  ruby_4_0,
  stdenv,
  yarnBuildHook,
  yarnConfigHook,
  yarnInstallHook,
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "prettier-plugin-ruby";
  packageName = "@prettier/plugin-ruby";
  version = "4.0.4";

  src = fetchFromGitHub {
    owner = "prettier";
    repo = "plugin-ruby";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gEgs2L7q6WX/Cwtf4hsFzKZeJs2oXBckfQxINq2/Ahg=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-KG6LwkBN3Ao85mIt244SNzOsLNxYM/g9meWJ5AknHis=";
  };

  yarnKeepDevDeps = true;

  patchPhase =
    let
      rubyDeps = with rubyPackages_4_0; [
        prettier_print
        syntax_tree
        syntax_tree-haml
        syntax_tree-rbs
      ];

      rubyEnv = ruby_4_0.withPackages (ps: rubyDeps);
    in
    ''
      sed -i '/default: "ruby"/ {
        s|ruby|${lib.getExe rubyEnv}|;
      }' ./src/plugin.js
    '';

  buildPhase = ''
    runHook preBuild

    ## Note: source code is raw/vanilla Oracle™ JavaScript® and Ruby so no build needed

    runHook postBuild
  '';

  installPhase = ''
    mkdir $out

    cp -r ./bin ./exe ./lib ./node_modules ./package.json ./prettier.gemspec ./src $out/
  '';

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    nodejs
  ];

  meta = {
    description = "Prettier Ruby Plugin";
    homepage = "https://github.com/prettier/prettier-ruby#readme";
    license = "MIT";
  };
})

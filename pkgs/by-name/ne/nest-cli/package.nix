{
  lib,
  stdenv,
  python3,
  clang_20,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "nest-cli";
  version = "11.0.18";

  src = fetchFromGitHub {
    owner = "nestjs";
    repo = "nest-cli";
    tag = finalAttrs.version;
    hash = "sha256-fqVsvox7c50bZ5jqGrpu3QiQG+ghY3eh8SETrdKnRCY=";
  };

  npmDepsHash = "sha256-1M53H0tLD3+9To4kxt136P7kOvzo3gfWEFkFlcUSy6g=";
  npmFlags = [ "--legacy-peer-deps" ];

  env = {
    npm_config_build_from_source = true;
  };

  nativeBuildInputs = [
    python3
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [ clang_20 ]; # clang_21 breaks gyp builds

  meta = {
    changelog = "https://github.com/nestjs/nest-cli/releases/tag/${finalAttrs.version}";
    description = "CLI tool for Nest applications";
    downloadPage = "https://github.com/nestjs/nest-cli";
    homepage = "https://nestjs.com";
    license = lib.licenses.mit;
    mainProgram = "nest";
    maintainers = with lib.maintainers; [
      ehllie
      phanirithvij
    ];
  };
})

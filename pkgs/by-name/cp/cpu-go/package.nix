{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  mdnsSupport ? stdenv.hostPlatform.isLinux,
  buildCpud ? stdenv.hostPlatform.isLinux,
}:

buildGoModule {
  pname = "cpu-go";
  version = "0-unstable-2024-10-17";

  src = fetchFromGitHub {
    owner = "u-root";
    repo = "cpu";
    rev = "54ca8c104060501ddc02ab5e3fc787d58feba1d8";
    hash = "sha256-+SQLxq7XKj2F81LrDpzs8c0VzTHdYg/fnVGlB75op3g=";
  };

  vendorHash = "sha256-0NBuVyyJG71jeghIohTuy9zi/qhDLqJa+jrPjR0C5co=";

  # Requires binding network port
  checkFlags = [ "-skip=^TestDnsSdStart$" ];

  tags = lib.optionals mdnsSupport [ "mDNS" ];

  # cpud is incomplete on platforms other than linux and cannot build
  # There is a PR in progress: https://github.com/u-root/cpu/pull/281
  excludedPackages = lib.optionals (!buildCpud) [ "cmds/cpud" ];

  meta = {
    description = "Implementation the Plan 9 cpu command in Go";
    homepage = "https://github.com/u-root/cpu";
    license = lib.licenses.bsd3;
    mainProgram = "cpu";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
  };
}

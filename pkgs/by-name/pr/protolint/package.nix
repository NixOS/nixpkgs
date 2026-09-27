{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "protolint";
  version = "0.57.0";

  src = fetchFromGitHub {
    owner = "yoheimuta";
    repo = "protolint";
    rev = "v${version}";
    hash = "sha256-n3/O1ZgEDrPfPaytT88dfZeECd65rIPs7SBb9uwJXEU=";
  };

  vendorHash = "sha256-XuURqNSOJXb3kg8tyohixS12I2M+UWbYhhyhHOJvNo4=";

  # Something about the way we run tests causes issues. It doesn't happen
  # when using "go test" directly:
  # === RUN   TestEnumFieldNamesPrefixRule_Apply_fix/no_fix_for_a_correct_proto
  #    util_test.go:35: open : no such file or directory
  # === RUN   TestEnumFieldNamesPrefixRule_Apply_fix/fix_for_an_incorrect_proto
  #    util_test.go:35: open : no such file or directory
  excludedPackages = [ "internal" ];

  ldflags =
    let
      rev = builtins.substring 0 7 src.rev;
    in
    [
      "-X github.com/yoheimuta/protolint/internal/cmd.version=${version}"
      "-X github.com/yoheimuta/protolint/internal/cmd.revision=${rev}"
      "-X github.com/yoheimuta/protolint/internal/cmd/protocgenprotolint.version=${version}"
      "-X github.com/yoheimuta/protolint/internal/cmd/protocgenprotolint.revision=${rev}"
    ];

  meta = {
    description = "Pluggable linter and fixer to enforce Protocol Buffer style and conventions";
    homepage = "https://github.com/yoheimuta/protolint";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = [ ];
    mainProgram = "protolint";
  };
}

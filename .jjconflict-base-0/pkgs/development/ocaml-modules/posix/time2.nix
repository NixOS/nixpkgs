{ lib, buildDunePackage, posix-base, posix-types, unix-errno }:

buildDunePackage {
  pname = "posix-time2";

  inherit (posix-base) version src;

  duneVersion = "3";

  propagatedBuildInputs = [ posix-base posix-types unix-errno ];

  doCheck = true;

  meta = posix-base.meta // {
    description = "posix-time2 provides the types and bindings for posix time APIs";
    maintainers = with lib.maintainers; [ dandellion ];
  };
}

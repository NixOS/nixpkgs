{ writeText
, utils
}:
let
  execution = {
    sandboxType = "none";
    executionType = "none";
    cewrapper.config.sandbox = "etc/cewrapper/user-execution.json";
    cewrapper.config.execute = "etc/cewrapper/compilers-and-tools.json";
  };
in
writeText "execution.defaults.properties" ''
  ${utils.attrToDot execution}
''

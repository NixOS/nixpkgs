{
  outputs = { self, subflake, callLocklessFlake }: rec {
    x = (callLocklessFlake {
      path = subflake;
      inputs = {};
    }).subflakeOutput;
  };
}

{
  inputs = {
    subflake.url = "path:subflake";
  };
  outputs = { self, subflake }: {
    x = subflake;
  };
}

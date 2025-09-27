{
  submodule =
    { foo, bar, ... }:
    {
      config = foo && bar;
    };
}

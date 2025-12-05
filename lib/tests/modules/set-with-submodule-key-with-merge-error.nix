{
  imports = [
    {
      set = [
        # Partial submodule, cannot evaluate
        # Because the default 'key = config.foo + config.bar;'
        {
          foo = "foo";
        }
      ];
    }
  ];
}

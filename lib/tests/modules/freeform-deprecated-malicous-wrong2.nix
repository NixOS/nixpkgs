# freeeformType should have been (attrsOf either)
# This should also print the warning
{
  config.either = {
    int = 42;
  };

  config.eitherBehindNullor = {
    int = 42;
  };

  config.oneOf = {
    int = 42;
  };

  config.number = {
    str = 42;
  };
}

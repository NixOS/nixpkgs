{

  config.value = {
    e = {
      before.c = true;
      before.a = true;
    };
    d = {
      after.e = true;
    };
    c = {
      after.e = true;
      before.b = true;
    };
    b = {
      after.d = true;
      before.a = true;
    };
    a = {
      after.d = true;
    };
  };
}

- The `django` alias in the python package set was upgraded to Django 4.x.
  Applications that consume Django should always pin their python environment
  to a compatible major version, so they can move at their own pace.

  ```nix
  python = python3.override {
    packageOverrides = self: super: {
      django = super.django_3;
    };
  };
  ```

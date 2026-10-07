{
  lib,
  buildPythonPackage,
  django,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-leaflet";
  version = "0.34.0";
  pyproject = true;

  src = fetchPypi {
    pname = "django_leaflet";
    inherit version;
    hash = "sha256-gzbnKnu/8LNjBUmC8CrB16O8srL6S8oyYBTd3q63xRU=";
  };

  build-system = [ setuptools ];

  dependencies = [ django ];

  # The tests seem to be impure.
  # They are throwing a error about unset configs:
  # > django.core.exceptions.ImproperlyConfigured: Requested setting LEAFLET_CONFIG, but settings are not configured.
  doCheck = false;

  # This dosn't work either because of the same exception as above
  # pythonImportsCheck = [ "leaflet" ];

  meta = {
    description = "Allows you to use Leaflet in your Django projects";
    homepage = "https://github.com/makinacorpus/django-leaflet";
    changelog = "https://github.com/makinacorpus/django-leaflet/blob/${version}/CHANGES";
    license = lib.licenses.lgpl3Only;
    maintainers = [ ];
  };
}

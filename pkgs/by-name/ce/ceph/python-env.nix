{
  ceph-python,
  ceph-python-common,
}:

# TODO: split this off in build and runtime environment
ceph-python.withPackages (
  ps: with ps; [
    ceph-python-common

    # build time
    cython_0

    # debian/control
    bcrypt
    cherrypy
    influxdb
    jinja2
    jmespath
    kubernetes
    natsort
    numpy
    pecan
    prettytable
    pyjwt
    pyopenssl
    python-dateutil
    pyyaml
    requests
    routes
    scikit-learn
    scipy
    setuptools
    sphinx
    virtualenv
    werkzeug
    xmltodict

    # src/cephadm/zipapp-reqs.txt
    markupsafe

    # src/pybind/mgr/requirements-required.txt
    cryptography
    jsonpatch

    # src/tools/cephfs/shell/setup.py
    cmd2
    colorama
  ]
)

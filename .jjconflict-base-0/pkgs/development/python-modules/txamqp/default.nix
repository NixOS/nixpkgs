{
  lib,
  buildPythonPackage,
  fetchPypi,
  twisted,
}:

buildPythonPackage rec {
  pname = "txamqp";
  version = "0.8.2";

  src = fetchPypi {
    pname = "txAMQP";
    inherit version;
    sha256 = "0jd9864k3csc06kipiwzjlk9mq4054s8kzk5q1cfnxj8572s4iv4";
  };

  propagatedBuildInputs = [ twisted ];

  meta = with lib; {
    homepage = "https://github.com/txamqp/txamqp";
    description = "Library for communicating with AMQP peers and brokers using Twisted";
    license = licenses.asl20;
    maintainers = [ ];
  };
}

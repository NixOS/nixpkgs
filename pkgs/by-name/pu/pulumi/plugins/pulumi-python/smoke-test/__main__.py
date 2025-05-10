from binascii import b2a_hex
from os import urandom

from pulumi import export, ResourceOptions
from pulumi.dynamic import Resource, ResourceProvider, CreateResult


class RandomProvider(ResourceProvider):
    def create(self, inputs):
        return CreateResult(b2a_hex(urandom(16)), outs={})


class Random(Resource):
    def __init__(self, name, opts = None):
         super().__init__(RandomProvider(), name, {}, opts)


export("out", Random(name="random_test").id)

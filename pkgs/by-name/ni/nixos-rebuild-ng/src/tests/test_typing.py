import enum
from dataclasses import dataclass

import nixos_rebuild.typing as t
from tests import helpers


def test_try_assign() -> None:
    assert t.try_assign(int, 1) == (True, 1)
    assert t.try_assign(str, True) == (False, None)
    assert t.try_assign(str | bool, "foo") == (True, "foo")
    assert t.try_assign(str | None, None) == (True, None)
    assert t.try_assign(str | None, 123) == (False, None)

    class MyEnum(enum.Enum):
        A = "foo"
        B = "bar"

    assert t.try_assign(MyEnum, "foo") == (True, MyEnum.A)
    assert t.try_assign(MyEnum, "baz") == (False, None)


def test_create_type_validator() -> None:
    @dataclass(kw_only=True)
    class FooBar:
        foo: str
        bar: int = 0
        baz: str | None

    foobar_validator = t.create_type_validator(FooBar)
    assert foobar_validator({"foo": "bar"}) == FooBar(foo="bar", bar=0, baz=None)
    assert foobar_validator({"foo": "baz", "bar": 10}) == FooBar(
        foo="baz", bar=10, baz=None
    )
    assert foobar_validator({"foo": "baz", "baz": "a str"}) == FooBar(
        foo="baz", bar=0, baz="a str"
    )

    helpers.assert_raises(lambda: t.create_type_validator(int))
    helpers.assert_raises(lambda: foobar_validator({"foo": 1}))
    helpers.assert_raises(lambda: foobar_validator({"foo": "bar", "bar": "not an int"}))
    helpers.assert_raises(lambda: foobar_validator({"foo": "bar", "baz": True}))

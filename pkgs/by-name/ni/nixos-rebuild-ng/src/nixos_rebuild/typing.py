import dataclasses
import types
from collections.abc import Callable, Mapping
from enum import Enum
from typing import Any, Literal, get_origin


def try_assign(
    cls: type | types.UnionType,
    value: Any,  # noqa: ANN401 - this function really accepts any value here
) -> tuple[Literal[True], Any] | tuple[Literal[False], None]:
    """
    Check if a value is assignable to a type, and if so, return the value with the correct type.
    """

    origin = get_origin(cls)

    if origin is None:
        assert isinstance(cls, type), "Only basic types should have no origin"

        if isinstance(value, cls):
            return True, value

        if issubclass(cls, Enum):
            if value in cls:
                return True, cls(value)

        return False, None

    if origin is types.UnionType:
        assert isinstance(cls, types.UnionType), (
            "Union types should have origin of UnionType"
        )

        for member in cls.__args__:
            result = try_assign(member, value)
            if result[0]:
                return result

        return False, None

    raise NotImplementedError(f"Unsupported type: {cls}")


def extract_init_fields(type_cls: type) -> list[dataclasses.Field[Any]]:
    if not dataclasses.is_dataclass(type_cls):
        raise TypeError("type_cls must be a dataclass")

    extracted_fields = list[dataclasses.Field[Any]]()

    for field in dataclasses.fields(type_cls):
        if not field.init:
            continue

        if isinstance(field.type, str):
            raise NotImplementedError(
                f"String type annotations are not supported: {field.name} in {type_cls}"
            )

        extracted_fields.append(field)

    return extracted_fields


def create_type_validator[T](type_cls: type[T]) -> Callable[[Mapping[str, Any]], T]:
    """
    Create a function that takes a mapping of string keys to any values, and
    returns an instance of the given type_cls.

    If the values are not assignable to the types of the attributes of type_cls,
    raises a TypeError with a detailed error message.
    """

    fields = extract_init_fields(type_cls)

    def validate_python(args: Mapping[str, Any]) -> T:
        typed_args = dict[str, Any]()
        validation_errors = list[tuple[str, str]]()

        for field in fields:
            assert not isinstance(field.type, str), (
                "String type annotations should have been rejected by extract_init_fields"
            )

            provided_value = None
            if field.name in args:
                provided_value = args.get(field.name)
            elif field.default is not dataclasses.MISSING:
                provided_value = field.default
            elif field.default_factory is not dataclasses.MISSING:
                provided_value = field.default_factory()

            is_assignable, typed_value = try_assign(field.type, provided_value)

            if not is_assignable:
                validation_errors.append(
                    (
                        field.name,
                        f"type {type(provided_value)} is not assignable to type {field.type}",
                    )
                )
            else:
                typed_args[field.name] = typed_value

        if validation_errors:
            raise TypeError(
                f"Type validation of {type_cls} failed with the following errors:\n\n"
                + "\n".join(f"  - {attr}: {error}" for attr, error in validation_errors)
            )

        return type_cls(**typed_args)

    return validate_python

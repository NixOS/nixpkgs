from typing import Any

_frozen_classes: dict[type, type] = {}

# make a derived class freezable (ie, disallow modifications).
# we do this by changing the class of an instance at runtime when freeze()
# is called, providing a derived class that is exactly the same except
# for a __setattr__ that raises an error when called. this beats having
# a field for frozenness and an unconditional __setattr__ that checks this
# field because it does not insert anything into the class dict.
class Freezeable:
    def freeze(self) -> None:
        cls = type(self)
        if not (frozen := _frozen_classes.get(cls)):
            def __setattr__(instance: Any, n: str, v: Any) -> None:
                raise TypeError(f'{cls.__name__} is frozen')
            frozen = type(cls.__name__, (cls,), {
                '__setattr__': __setattr__,
            })
            _frozen_classes[cls] = frozen
        self.__class__ = frozen

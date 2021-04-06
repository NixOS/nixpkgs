/* === This file is part of Calamares - <https://calamares.io> ===
 *
 *   SPDX-FileCopyrightText: 2021 Adriaan de Groot <groot@kde.org>
 *   SPDX-License-Identifier: GPL-3.0-or-later
 *
 *   Calamares is Free Software: see the License-Identifier above.
 *
 */

#include "Config.h"

#include <utils/Logger.h>
#include <utils/NamedEnum.h>
#include <utils/Variant.h>

Config::Config( QObject* parent )
    : Calamares::ModuleSystem::Config( parent )
{
}

Config::~Config() {}

static const NamedEnumTable< UnpackEntry::Type > typeNames()
{
    using T = UnpackEntry::Type;

    static const NamedEnumTable< T > names {
        { "none", T::None },
        { "fsarchiver", T::FSArchive },
        { "fsarchive", T::FSArchive },
        { "fsa", T::FSArchive }
    };

    return names;
}

void
Config::setConfigurationMap( const QVariantMap& map )
{
    Logger::Once o;

    const auto items = map["unpack"].toList();
    for( const auto& i : items )
    {
        QVariantMap entryData = i.toMap();
        QString source = CalamaresUtils::getString(entryData, "source" );
        QString sourceTypeName = CalamaresUtils::getString(entryData, "sourcefs" );
        if ( source.isEmpty() || sourceTypeName.isEmpty() )
        {
            cDebug() << o << "Skipping item with bad source data:" << entryData;
            continue;
        }
        bool bogus = false;
        UnpackEntry::Type sourceType = typeNames().find( sourceTypeName, bogus );
        if ( sourceType == UnpackEntry::Type::None )
        {
            cDebug() << o << "Skipping item with source type None";
            continue;
        }
        QString destination = CalamaresUtils::getString(entryData, "destination" );
        if ( destination.isEmpty() )
        {
            cDebug() << o << "Skipping item with empty destination";
            continue;
        }
        m_entries.append( { source, destination, sourceType } );
    }
}
